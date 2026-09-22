with cust_invoice as (
    select
          c.customer_id,
          c.region,
          c.segment,
          c.offer_code,
          c.period_start,
          c.SUM_AMOUNT_TTC,
          c.AVG_AMOUNT_TTC,
          f.is_churned_flag
    from {{ref('int_customers_invoices')}} c
    left join {{ref('int_customers')}} f on (f.customer_id = c.customer_id)
),
cust_usage as (
    select
         u.customer_id,
         u.period_month,
         u.total_data_used
    from {{ref('int_customers_usage')}} u
),
churn_signal as (
    select  r.CUSTOMER_ID,
            r.nb_depassement,
            r.NB_SLA_BREACH,
            r.NB_INCIDENT,
            r.AVG_NPS_SCORE,
            r.NB_OPEN_INCIDENTS,
            r.NB_INVOICES,
            r.churn_score,
            r.TOTAL_FAC_RETARD
    from {{ ref('int_churn_signals') }} r
),

final as (
    select 
          c.customer_id,
          c.region,
          c.segment,
          c.offer_code,
          c.period_start,
          c.SUM_AMOUNT_TTC,
          c.AVG_AMOUNT_TTC,
          c.is_churned_flag,
          u.period_month,
          u.total_data_used,
          r.nb_depassement,
          r.NB_SLA_BREACH,
          r.NB_INCIDENT,
          r.AVG_NPS_SCORE,
          r.NB_OPEN_INCIDENTS,
          r.NB_INVOICES,
          r.TOTAL_FAC_RETARD,
          r.churn_score
    from cust_invoice c 
    left join cust_usage u on (u.customer_id = c.customer_id)
                              --and u.period_month = c.period_start)
    left join churn_signal r on (r.customer_id = c.customer_id)
)

select * from final