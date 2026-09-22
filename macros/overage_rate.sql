{% macro overage_rate(data_used, data_limit) %}
    CASE 
        WHEN {{ data_limit }} IS NULL OR {{ data_limit }} = 0 THEN NULL
        ELSE ROUND({{ data_used }} / {{ data_limit }} * 100, 2)
    END
{% endmacro %}