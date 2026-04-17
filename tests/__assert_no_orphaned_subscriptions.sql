select subscription_id
from {{ ref('stg_subscriptions') }} s
left join {{ ref('stg_customers') }} c
    on c.customer_id = s.customer_id
where c.customer_id is null