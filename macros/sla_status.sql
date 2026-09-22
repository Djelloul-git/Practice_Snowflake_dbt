{% macro status_sla(resol_hours, sla_hour) %}
    IFF({{ resol_hours }} <= {{ sla_hour }}, 'OK', 'BREACH')
{% endmacro %}