select 
	INCIDENT_ID,
	CUSTOMER_ID,
	INCIDENT_TYPE,
	SEVERITY,
	STATUS,
	CHANNEL,
	to_timestamp(OPENED_AT) as OPENED_AT,
	to_timestamp(CLOSED_AT) as CLOSED_AT,
	cast(RESOLUTION_HOURS as float) as RESOLUTION_HOURS,
    datediff(hour, to_timestamp(OPENED_AT), to_timestamp(CLOSED_AT)) as real_resolution_hours,
	cast(SLA_HOURS as integer) as SLA_HOURS,
	cast(SLA_BREACH as boolean) as SLA_BREACH,
	cast(NPS_SCORE as float) as NPS_SCORE,
	to_timestamp(CREATED_AT) as CREATED_AT
from {{source('data_raw', 'incidents')}}