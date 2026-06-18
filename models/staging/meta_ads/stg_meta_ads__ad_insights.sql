with source as (
    select * from {{ source('raw_paid_media', 'meta_ads_ad_insights') }}
)

select
    workspace_id,
    cast(date as date) as insight_date,
    campaign_id,
    adset_id,
    ad_id,
    impressions,
    clicks,
    spend,
    reach,
    cast(conversions as {{ dbt.type_float() }}) as conversions,
    conversion_value
from source
