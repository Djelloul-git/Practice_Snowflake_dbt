-- Ce test échoue si amount_ttc > 0
select *
from {{ ref('stg_invoices') }} f
where f.amount_ttc  is not null
  and f.amount_ttc <= 0