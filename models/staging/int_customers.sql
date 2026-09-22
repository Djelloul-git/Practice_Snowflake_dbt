with flag_custom as (select
                            c.customer_id,
                            MAX(i.period_start) as last_invoice_date,
                            {{ is_churned('MAX(i.period_start)', 3) }} as is_churned_flag
                        from {{ ref('stg_customers') }} c
                        left join {{ ref('stg_invoices') }} i
                            on c.customer_id = i.customer_id
                        group by c.customer_id
),
over_rate as (select
                        c.customer_id,
                        AVG({{ overage_rate('u.DATA_USED_GB', 'u.DATA_LIMIT_GB') }}) as overage_rate
                    from {{ ref('stg_customers') }} c
                    left join {{ ref('stg_usage') }} u
                        on c.customer_id = u.customer_id
                    group by c.customer_id
),

final as (select c.*, 
                 f.last_invoice_date,
                 f.is_churned_flag,
                 r.overage_rate

from {{ ref('stg_customers') }} c
left join flag_custom f on (f.customer_id = c.customer_id)
left join over_rate r on (r.customer_id = c.customer_id)

)
select * from final 

