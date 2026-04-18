select 
    subscription_id
from {{ ref('int_lifecycle') }}
where monthly_fee < 0