with final as (
    select
        c.customer_id,
        c.region,
        c.segment,
        c.offer_code,
        c.is_churned_flag,
        SUM(c.SUM_AMOUNT_TTC)    as total_revenue,
        AVG(c.AVG_AMOUNT_TTC)    as avg_monthly_revenue,
        SUM(c.total_data_used)   as total_data_used,
        c.nb_depassement,
        c.NB_SLA_BREACH,
        c.NB_INCIDENT,
        c.NB_INVOICES,
        c.TOTAL_FAC_RETARD,
        c.AVG_NPS_SCORE,
        c.churn_score
    from {{ ref('mart_customer_monthly') }} c
    group by
        c.customer_id,
        c.region,
        c.segment,
        c.offer_code,
        c.is_churned_flag,
        c.nb_depassement,
        c.NB_SLA_BREACH,
        c.NB_INCIDENT,
        c.NB_INVOICES,
        c.TOTAL_FAC_RETARD,
        c.AVG_NPS_SCORE,
        c.churn_score
)
select * from final