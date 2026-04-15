with 
    source as(
        select *
        from {{source('ev_rawdata', 'raw_vehicles')}}
),
    renamed as(
        select
            vehicle_id,
            model,
            battery_range_km,
            age_months,
            fleet_id,
            cast(procurement_date as date) as procurement_date,
        from source
    )
select * from renamed
