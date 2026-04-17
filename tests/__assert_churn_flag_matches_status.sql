select subscription_id
from {{ ref('int_lifecycle') }}
where 
    (status = 'cancelled' and is_churned is false)
    or (status = 'active' and is_churned is true)
