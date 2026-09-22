with conso as (
    select
        c.region,
        c.segment,
        c.offer_code,
        c.period_start,
        i.INCIDENT_TYPE,
        i.CHANNEL,
        AVG(ref_c.total_data_used) as total_data_used,
        AVG(cu.overage_rate) as overage_rate,
        AVG(i.NPS_SCORE) as NPS_SCORE
    from {{ ref('mart_customer_monthly') }} c
    left join {{ ref('int_customers_usage') }} ref_c on ( ref_c.customer_id = c.customer_id)
    left join {{ ref('int_customers') }} cu on ( cu.customer_id = c.customer_id)
    left join {{ ref('int_incidents') }} i on ( i.customer_id = c.customer_id)
    group by
        c.region,
        c.segment,
        c.offer_code,
        c.period_start,
        i.INCIDENT_TYPE,
        i.CHANNEL
),
incident_rate  as (
                    select
                        i.INCIDENT_TYPE,
                        COUNT_IF(i.SLA_BREACH = true)/COUNT(i.INCIDENT_ID)    as SLA_BREACH_RATE
                    from {{ ref('int_incidents') }} i
                    group by i.INCIDENT_TYPE
),

final as (
    select c.*, i.SLA_BREACH_RATE
    from conso c
    left join incident_rate i on (i.INCIDENT_TYPE = c.INCIDENT_TYPE)
)


select * from final