select
    gaa.ad_id as ad_id,
    gaa.campaign_id as campaign_id,
    gaa.ad_type as ad_type,
    gac.campaign_name as campaign_name
from {{ source('raw_paid_media', 'google_ads_ads') }} as gaa
inner join {{ source('raw_paid_media', 'google_ads_campaigns') }} as gac
    on gaa.campaign_id = gac.campaign_id
