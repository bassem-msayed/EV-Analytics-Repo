select subscription_id
from {{ ref('int_lifecycle') }}
where subscription_duration_days < 0
