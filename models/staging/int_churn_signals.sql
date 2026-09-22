{{
    config(
        materialized='table'
    )
}}

with incident_signals  as (
                            select
                                c.CUSTOMER_ID,
                                COUNT(i.INCIDENT_ID)            as NB_INCIDENT,
                                COUNT_IF(i.SLA_BREACH = true)   as NB_SLA_BREACH,
                                AVG(i.NPS_SCORE)                as AVG_NPS_SCORE,
                                COUNT_IF(i.STATUS = 'OPEN')     as NB_OPEN_INCIDENTS
                            from {{ ref('int_customers_invoices') }} c
                            left join {{ ref('int_incidents') }} i
                                on c.customer_id = i.customer_id
                            group by c.CUSTOMER_ID
),
invoices_signals as (
                        select c.CUSTOMER_ID,
                               SUM(NB_INVOICES)   as NB_INVOICES,
                               SUM(NB_FAC_RETARD)  as TOTAL_FAC_RETARD
                        from {{ ref('int_customers_invoices') }} c
                        group by c.CUSTOMER_ID

),
usage_signals  as (
    select c.CUSTOMER_ID,
           COUNT_IF(c.overage_rate > 100) as nb_depassement
    from {{ ref('int_customers') }} c
    group by c.CUSTOMER_ID
),
finale as (
    select
        u.CUSTOMER_ID,
        u.nb_depassement,
        i.NB_SLA_BREACH,
        i.NB_INCIDENT,
        i.AVG_NPS_SCORE,
        i.NB_OPEN_INCIDENTS,
        f.NB_INVOICES,
        f.TOTAL_FAC_RETARD,

        -- Score de churn
        case when i.NB_OPEN_INCIDENTS > 0  then 15 else 0 end
        + case when i.NB_SLA_BREACH > 1    then 15 else 0 end
        + case when i.AVG_NPS_SCORE < 5    then 5  else 0 end
        + case when u.nb_depassement > 2   then 20 else 0 end
        + case when f.TOTAL_FAC_RETARD > 0 then 5  else 0 end
        as churn_score,

        -- Risque
        case
            when churn_score >= 40 then 'HIGH'
            when churn_score >= 20 then 'MEDIUM'
            else 'LOW'
        end as churn_risk

    from usage_signals u
    left join invoices_signals f on u.customer_id = f.customer_id
    left join incident_signals i on u.customer_id = i.customer_id
)

select * from finale