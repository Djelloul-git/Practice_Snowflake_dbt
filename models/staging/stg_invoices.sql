select 
	INVOICE_ID,
	CUSTOMER_ID,
	to_date(PERIOD_START) as PERIOD_START,
	to_date(PERIOD_END) as PERIOD_END,
	OFFER_CODE,
	cast(AMOUNT_HT as float) as AMOUNT_HT,
	cast(TVA as float) as TVA,
	cast(AMOUNT_TTC as  float) as AMOUNT_TTC,
	cast(DISCOUNT as integer) as DISCOUNT,
	to_date(DUE_DATE) as DUE_DATE,
	to_date(PAYMENT_DATE) as PAYMENT_DATE,
	STATUS,
	to_timestamp(CREATED_AT) as CREATED_AT,
    datediff(day, to_date(DUE_DATE), to_date(PAYMENT_DATE)) as days_to_pay
from {{source('data_raw', 'invoices')}}