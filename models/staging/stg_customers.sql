with 
    source as (
        select *
        from {{source('ev_rawdata', 'raw_customers')}}
    ),
    renamed as (
        select
            customer_id,
            full_name,
            email,
            acquisition_channel,
            region,
            customer_segment,
            cast(signup_date as date) as signup_date
        from source
    )
select * from renamed
