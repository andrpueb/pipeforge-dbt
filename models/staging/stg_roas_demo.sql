select
    gs.session_start as session_start,
    gs.session_date as session_date,
    gs.user_pseudo_id as user_pseudo_id,
    gs.workspace_id as workspace_id
from {{ source('raw_paid_media', 'ga4_sessions') }} as gs
