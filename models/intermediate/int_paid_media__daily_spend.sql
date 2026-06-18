-- Cross-channel daily ad performance at (workspace, date, channel, campaign) grain.
-- Meta + Google are stacked (UNION ALL) and rolled up; `campaign` is the
-- utm_campaign value, the join key the whole project hangs off.

with meta as (
    select
        i.workspace_id,
        i.insight_date as activity_date,
        'meta' as channel,
        c.campaign_name as campaign,
        i.impressions,
        i.clicks,
        i.spend,
        i.conversions,
        i.conversion_value
    from {{ ref('stg_meta_ads__ad_insights') }} as i
    inner join {{ ref('stg_meta_ads__campaigns') }} as c
        on
            i.workspace_id = c.workspace_id
            and i.campaign_id = c.campaign_id
),

google as (
    select
        p.workspace_id,
        p.report_date as activity_date,
        'google' as channel,
        c.campaign_name as campaign,
        p.impressions,
        p.clicks,
        p.cost as spend,
        p.conversions,
        p.conversion_value
    from {{ ref('stg_google_ads__ad_performance') }} as p
    inner join {{ ref('stg_google_ads__campaigns') }} as c
        on
            p.workspace_id = c.workspace_id
            and p.campaign_id = c.campaign_id
),

unioned as (
    select * from meta
    union all
    select * from google
)

select
    workspace_id,
    activity_date,
    channel,
    campaign,
    sum(impressions) as impressions,
    sum(clicks) as clicks,
    sum(spend) as spend,
    sum(conversions) as conversions,
    sum(conversion_value) as conversion_value
from unioned
group by workspace_id, activity_date, channel, campaign
