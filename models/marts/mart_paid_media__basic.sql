-- mart_paid_media__basic
-- The first hand-built deliverable (Phase 0). One row per
-- (workspace, day, channel, campaign) unifying Meta + Google spend with GA4
-- session/revenue context. Efficiency metrics live as columns here (ADR 0006:
-- metrics as mart columns in v1). No attribution modelling — that is Phase 3.

with spend as (
    select * from {{ ref('int_paid_media__daily_spend') }}
),

ga4 as (
    select * from {{ ref('int_ga4__sessions_daily') }}
)

select
    -- portable natural-key surrogate (no dbt_utils dependency)
    concat(
        cast(s.workspace_id as {{ dbt.type_string() }}), '|',
        cast(s.activity_date as {{ dbt.type_string() }}), '|',
        s.channel, '|', s.campaign
    ) as paid_media_key,
    s.workspace_id,
    s.activity_date,
    s.channel,
    s.campaign,

    -- ad-platform metrics
    s.impressions,
    s.clicks,
    s.spend,
    s.conversions,
    s.conversion_value as revenue,

    -- GA4 context (left-joined; null when a campaign drove no sessions that day)
    coalesce(g.sessions, 0) as ga4_sessions,
    coalesce(g.users, 0) as ga4_users,
    coalesce(g.ga4_conversions, 0) as ga4_conversions,
    coalesce(g.ga4_revenue, 0) as ga4_revenue,

    -- efficiency metrics (nullif keeps this portable and divide-by-zero safe)
    s.clicks / nullif(s.impressions, 0) as ctr,
    s.spend / nullif(s.clicks, 0) as cpc,
    s.spend / nullif(s.conversions, 0) as cpa,
    s.conversion_value / nullif(s.spend, 0) as roas
from spend as s
left join ga4 as g
    on
        s.workspace_id = g.workspace_id
        and s.activity_date = g.activity_date
        and s.campaign = g.campaign
