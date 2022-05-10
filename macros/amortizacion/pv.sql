{% macro pv(pay_type, pmt, fv, rate, nper) %}

{% if pay_type == 0 %}
{% set k=1 %}
{% set pv = ((pmt*k) / rate) - fv %}
{% set pv = pv / ((1 + rate)**nper) %}
{% set pv = pv - (pmt * k)/rate %}
    
{% else %}
{% set k= 1 + rate %}
{% set pv = ((pmt*k) / rate) - fv %}
{% set pv = pv / ((1 + rate)**nper) %}
{% set pv = pv - (pmt * k)/rate %}

{% endif %}

{{ return(pv) }}

{% endmacro %}
