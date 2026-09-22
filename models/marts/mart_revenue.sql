with revenu_tt as (
    select
        c.region,
        c.segment,
        c.offer_code,
        SUM(c.total_revenue)    as total_revenue
    from {{ ref('mart_customer_360') }} c
    group by
        c.region,
        c.segment,
        c.offer_code
),
Taux_facture_r as (
    select
        c.region,
        c.segment,
        c.offer_code,
        c.period_start,
        SUM(c.SUM_AMOUNT_TTC)    as total_revenue_mois,
        SUM(TOTAL_FAC_RETARD)/NULLIF(SUM(NB_INVOICES), 0) * 100 as taux_fac_retard
    from {{ ref('mart_customer_monthly') }} c
    group by
        c.region,
        c.segment,
        c.offer_code,
        c.period_start
),
with_ytd as (
    select *,
        SUM(total_revenue_mois) OVER (
            PARTITION BY region, segment, offer_code, DATE_TRUNC('year', period_start)
            ORDER BY period_start
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) as cumul_ytd
    from Taux_facture_r
), 
final as (
    select r.region,
           r.segment,
           r.offer_code,
           r.total_revenue,
           t.period_start,
           t.total_revenue_mois,
           y.cumul_ytd,
           t.taux_fac_retard,
           LAG(t.total_revenue_mois) OVER (PARTITION BY t.region, t.segment, t.offer_code ORDER BY t.period_start) AS revenue_mom
    from Taux_facture_r t
    left join revenu_tt r on (t.region = r.region
                             and t.segment = r.segment
                             and t.offer_code = r.offer_code
                             )
    left join with_ytd y on (y.region = r.region
                             and y.segment = r.segment
                             and y.offer_code = r.offer_code
                             and y.period_start = t.period_start
                             )
)
select * from final