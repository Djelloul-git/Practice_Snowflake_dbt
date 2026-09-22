-- Clients avec date de souscription dans le futur
select 'stg_customers' as source_model, customer_id as record_id, subscription_date as future_date
from {{ ref('stg_customers') }}
where subscription_date > current_date()

union all

-- Factures avec date de création dans le futur
select 'stg_invoices' as source_model, invoice_id as record_id, created_at::date as future_date
from {{ ref('stg_invoices') }}
where created_at > current_timestamp()

union all

-- Incidents ouverts dans le futur
select 'stg_incidents' as source_model, incident_id as record_id, opened_at::date as future_date
from {{ ref('stg_incidents') }}
where opened_at > current_timestamp()