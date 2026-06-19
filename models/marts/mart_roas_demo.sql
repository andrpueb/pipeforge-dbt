select
    cc.country as country,
    cc.full_name as full_name,
    cd.stage as stage,
    cc.workspace_id as workspace_id
from {{ source('raw_paid_media', 'crm_deals') }} as cd
inner join {{ source('raw_paid_media', 'crm_contacts') }} as cc
    on cd.workspace_id = cc.workspace_id
