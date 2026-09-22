{{
    config(
        materialized='incremental',
        unique_key='INVOICE_ID',
        incremental_strategy='merge'
    )
}}

select 
        i.INVOICE_ID,
        i.CUSTOMER_ID,
        i.PERIOD_START,
        i.PERIOD_END,
        i.OFFER_CODE,
        i.AMOUNT_HT,
        i.TVA,
        i.AMOUNT_TTC,
        i.DISCOUNT,
        i.DUE_DATE,
        i.PAYMENT_DATE,
        i.STATUS,
        i.CREATED_AT,
        i.DAYS_TO_PAY
from {{ ref('stg_invoices') }} i

{% if is_incremental() %}
    -- Ne sélectionne que les enregistrements plus récents que le maximum existant
    where i.CREATED_AT > (select max(CREATED_AT) from {{ this }})
{% endif %}