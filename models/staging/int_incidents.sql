select 
	inc.INCIDENT_ID,
	inc.CUSTOMER_ID,
	inc.INCIDENT_TYPE,
	inc.SEVERITY,
	inc.STATUS,
	inc.CHANNEL,
	inc.OPENED_AT,
	inc.CLOSED_AT,
	inc.RESOLUTION_HOURS,
    inc.real_resolution_hours,
	inc.SLA_HOURS,
	inc.SLA_BREACH,
	inc.NPS_SCORE,
	inc.CREATED_AT,
	{{status_sla('inc.real_resolution_hours', 'inc.SLA_HOURS')}} as status_sla_calcule
from {{ref('stg_incidents')}} inc