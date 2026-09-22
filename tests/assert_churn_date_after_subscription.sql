-- Ce test échoue si churn_date <= subscription_date
select *
from {{ ref('stg_customers') }}
where churn_date is not null
  and churn_date <= subscription_date