select 
    subscription_id,
    count(*) as n
from {{ ref('int_lifecycle') }}
group by subscription_id
having count(*) > 1