with source as (
    select * from {{ source('raw_paid_media', 'meta_ads_campaigns') }}
)

select
    workspace_id,
    campaign_id,
    account_id,
    campaign_name,
    objective,
    status,
    daily_budget
from source
