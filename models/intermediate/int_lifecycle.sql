with deduplicate_subscriptions as (
    select 
        *, 
        row_number() over (
            partition by subscription_id
            order by start_date
        ) as row_num
    from {{ ref('stg_subscriptions') }}
),
clean_subscription as (
    select * except row_num
    from deduplicate_subscriptions
    where row_num = 1
),
base as (
    select 
        --customer data
        c.customer_id,
        c.full_name,
        c.email,
        c.acquisition_channel,
        c.region,
        c.customer_segment,
        c.signup_date,
        --vehicle data
        v.vehicle_id,
        v.model,
        v.battery_range_km,
        v.age_months,
        v.fleet_id,
        v.procurement_date, 
        --subscription data
        s.subscription_id,
        s.start_date,
        s.end_date,
        s.monthly_fee,
        s.plan_tier,
        s.status,
        s.cancellation_reason,
        --derived fields
        date_diff(s.end_date, s.start_date, day) as subscription_duration_days,
        case when s.status = 'cancelled' then true else false end as is_churned,
        row_number() over(
            partition by s.customer_id
            order by s.start_date
        ) as subscription_number,
        lag(s.status) over(
            partition by s.customer_id
            order by s.start_date
        ) as previous_subscription_status
    from {{ ref('stg_customers') }} c
    left join {{ ref('stg_subscriptions') }} s on s.customer_id = c.customer_id
    left join {{ ref('stg_vehicles') }} v on v.vehicle_id = s.vehicle_id
)

select * from base