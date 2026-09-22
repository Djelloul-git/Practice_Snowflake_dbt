with Taux_churn as (
    select
        c.region,
        c.segment,
        c.offer_code,
        c.period_start,
        COUNT_IF(c.is_churned_flag = true)/NULLIF(COUNT(c.customer_id), 0) * 100   as taux_churn,
        AVG(DATEDIFF('month', ref_c.subscription_date, ref_c.churn_date)) as avg_months_before_churn
    from {{ ref('mart_customer_monthly') }} c
    left join {{ ref('int_customers') }} ref_c on ( ref_c.customer_id = c.customer_id
                                                    and ref_c.is_churned = true
                                                    and ref_c.churn_date is not null
                                                   )
    group by
        c.region,
        c.segment,
        c.offer_code,
        c.period_start
),

final as (
            select
                t.region,
                t.segment,
                t.offer_code,
                t.period_start,
                t.taux_churn,
                t.avg_months_before_churn,
                c.churn_score
            from Taux_churn t
            left join {{ ref('mart_customer_360') }} c
                on c.offer_code = t.offer_code
                and c.segment = t.segment
                and c.region = t.region
)
select * from final