with source as (
    select * from {{ source('raw_paid_media', 'google_ads_ad_performance_report') }}
)

select
    workspace_id,
    cast(date as date) as report_date,
    campaign_id,
    ad_group_id,
    ad_id,
    impressions,
    clicks,
    cost_micros / 1000000.0 as cost,
    cast(conversions as {{ dbt.type_float() }}) as conversions,
    conversions_value as conversion_value
from source
