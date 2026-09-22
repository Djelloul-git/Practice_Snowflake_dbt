-- Ce test échoue si amount_ttc > 0
select *
from {{ ref('stg_incidents') }} f
where f.closed_at is not null 
and f.closed_at < f.opened_at