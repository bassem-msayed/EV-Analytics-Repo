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
            case
                when lower(trim(region)) in ('bavaria', 'bayern', 'by') then 'Bavaria'
                when lower(trim(region)) in ('hamburg', 'hh') then 'Hamburg'
                when lower(trim(region)) in ('berlin') then 'Berlin'
                when lower(trim(region)) in ('north rhine-westphalia', 'nrw') then 'North Rhine-Westphalia'
                else region
            end as region,
            customer_segment,
            cast(signup_date as date) as signup_date
        from source
    )
select * from renamed
