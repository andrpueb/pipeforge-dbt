with source as (
    select * from {{ source('raw_paid_media', 'google_ads_campaigns') }}
)

select
    workspace_id,
    campaign_id,
    customer_id,
    campaign_name,
    advertising_channel_type,
    status,
    budget_amount_micros / 1000000.0 as daily_budget
from source
