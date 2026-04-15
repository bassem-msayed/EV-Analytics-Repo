with 
    source as (
        select *
        from {{source('ev_rawdata', 'raw_subscriptions')}}
    ),
    renamed as (
        select
            subscription_id,
            customer_id,
            vehicle_id,
            cast(start_date as date) as start_date,
            cast(end_date as date) as end_date,
            monthly_fee,
            plan_tier,
            status,
            cancellation_reason
        from source
    )
select * from renamed