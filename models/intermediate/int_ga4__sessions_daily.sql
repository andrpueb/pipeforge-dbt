-- GA4 sessions rolled up to (workspace, date, campaign) so they can enrich the
-- paid-media mart. This is a simple last-non-direct-style attachment by
-- utm_campaign, NOT a real attribution model (that is Phase 3).

with sessions as (
    select * from {{ ref('stg_ga4__sessions') }}
)

select
    workspace_id,
    session_date as activity_date,
    utm_campaign as campaign,
    count(*) as sessions,
    count(distinct user_pseudo_id) as users,
    sum(case when is_conversion then 1 else 0 end) as ga4_conversions,
    sum(revenue) as ga4_revenue
from sessions
group by workspace_id, session_date, utm_campaign
