with source as (
    select * from {{ source('raw_paid_media', 'ga4_sessions') }}
)

select
    workspace_id,
    session_id,
    user_pseudo_id,
    cast(session_date as date) as session_date,
    session_start,
    source as utm_source,
    medium as utm_medium,
    campaign as utm_campaign,
    device_category,
    country,
    page_views,
    engaged,
    is_conversion,
    revenue
from source
