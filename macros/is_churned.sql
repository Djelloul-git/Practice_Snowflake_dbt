{% macro is_churned(invoice_date_col, months=3) %}
    DATEDIFF(month, {{ invoice_date_col }}, CURRENT_DATE()) > {{ months }}
{% endmacro %}