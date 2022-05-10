{% macro pmt(pay_type, pv, fv, rate, nper) %}

{% if pay_type == 0 %}

{% set pmt= (pv+((pv+fv)/(((1+rate)**nper)-1)))*rate %}

{% elif pay_type == 1 %}

{% set pmt= (pv + ((pv + fv)/(((1 + rate)**nper)-1)))*(rate/(1+rate)) %}

{% endif %}

{{ return(pmt) }}

    
{% endmacro %}