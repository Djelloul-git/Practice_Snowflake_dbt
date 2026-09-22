{{
    config(
        materialized='table'
    )
}}

with base as (
                select
                    c.customer_id,
                    u.period_month,
                    SUM(u.data_used_gb) as total_data_used
                from {{ ref('int_customers') }} c
                left join {{ ref('stg_usage') }} u 
                    on c.customer_id = u.customer_id
                group by
                    c.customer_id,
                    u.period_month
)

select
    customer_id,
    period_month,
    total_data_used,
    SUM(total_data_used) over (
        partition by customer_id
        order by period_month
        rows between 2 preceding and current row
    ) as rolling_3m_data_used
from base


