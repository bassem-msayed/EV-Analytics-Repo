with base as (
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
        s.cancellation_reason
    from {{ ref('stg_customers') }} c
    join {{ ref('stg_subscriptions') }} s on s.customer_id = c.customer_id
    join {{ ref('stg_vehicles') }} v on v.vehicle_id = s.vehicle_id
)

select * from base