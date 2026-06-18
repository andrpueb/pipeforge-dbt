select
    gs.country as country,
    gs.session_date as session_date,
    gs.landing_page as landing_page,
    gaa.campaign_id as campaign_id,
    gaa.ad_id as ad_id
from {{ source('raw_paid_media', 'ga4_sessions') }} as gs
inner join {{ source('raw_paid_media', 'google_ads_ads') }} as gaa
    on gs.workspace_id = gaa.workspace_id
