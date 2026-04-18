with base as(
    select * from {{ ref('int_lifecycle') }}
),
final as(
    select
        -----------------
        --keys
        -----------------
        customer_id,
        subscription_id,
        vehicle_id,
        -----------------
        --dimensions
        -----------------
        customer_segment,
        region as customer_region,
        acquisition_channel,
        start_date,
        end_date,
        monthly_fee,
        model as vehicle_model,
        is_churned as churn_flag,
        cancellation_reason,
        -----------------
        --calculations
        -----------------
        format_date('%Y-%m', start_date) as subscription_start_month, --for the axis
        date_diff(
            coalesce(end_date,current_date()), --to either or based on null or not
            start_date,
            day
        ) as days_active, --active measure to today & churned measured to end_date
        ntile(4) over(
            order by date_diff(
                coalesce(end_date,current_date()), 
                start_date,
                day
                )
        ) as tenure_quartile, --no partition as we want global visibility on percentile tenure
        sum(
            case when is_churned then 1 else 0 end
        ) over(
            order by start_date
            rows between unbounded preceding and current row 
        ) as cummulative_churn --to visualize the progressive churn trend
    from base
)

select * from final