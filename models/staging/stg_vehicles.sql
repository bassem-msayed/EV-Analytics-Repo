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
            case 
                when trim(lower(fleet_id)) = 'fl-east' then 'east'
                when trim(lower(fleet_id)) = 'fl-west' then 'west'
                when trim(lower(fleet_id)) = 'fl-north' then 'north'
                when trim(lower(fleet_id)) = 'fl-south' then 'south'
                else trim(lower(fleet_id))
                end as fleet_id,
            cast(procurement_date as date) as procurement_date
        from source
    )
select * from renamed
