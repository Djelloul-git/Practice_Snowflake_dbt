{{
    config(
        materialized='table'
    )
}}

select
    c.customer_id,
    c.region,
    c.segment,
    c.offer_code,
    DATE_TRUNC('month', i.period_start)  as period_start,
    SUM(AMOUNT_TTC) as SUM_AMOUNT_TTC,
    AVG(AMOUNT_TTC) as AVG_AMOUNT_TTC,
    SUM(DISCOUNT) as TOTAL_DISCOUNT,
    AVG(DAYS_TO_PAY) as AVG_DAYS_TO_PAY,
    COUNT(INVOICE_ID) as NB_INVOICES,
    COUNT_IF(STATUS='LATE') as NB_Fac_Retard
from {{ ref('int_customers') }} c
left join {{ ref('int_invoices_incremental') }} i
    on c.customer_id = i.customer_id
GROUP BY 
    c.customer_id,
    c.region,
    c.segment,
    c.offer_code,
    DATE_TRUNC('month', i.period_start) 


