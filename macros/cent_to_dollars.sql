
{% macro cents_to_dollars(column_name, presicion=2) %}
    round(({{ column_name }} / 100), {{ presicion }})
{% endmacro %}
