select 
	USAGE_ID,
	CUSTOMER_ID,
	to_date(PERIOD_MONTH || '-01') as PERIOD_MONTH,
	cast(DATA_USED_GB as float) as DATA_USED_GB,
	cast(DATA_LIMIT_GB as float) as DATA_LIMIT_GB,
	cast(VOICE_MINUTES as integer) as VOICE_MINUTES,
    cast(SMS_COUNT as integer) as SMS_COUNT,
	cast(ROAMING_MB as float) as ROAMING_MB,
	cast(OVERAGE_FLAG as boolean) as IS_OVERAGE,
	to_timestamp(CREATED_AT) as CREATED_AT
from {{source('data_raw', 'usage')}}