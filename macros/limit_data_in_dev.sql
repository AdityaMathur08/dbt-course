{% macro limit_data_in_dev(column_name) %}

{% if target.name == 'development' %}
where {{column_name}} >= dateadd('day',-30,current_timestamp)
{% endif %}
    
{% endmacro %}