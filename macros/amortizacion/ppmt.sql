{% macro ppmt(rate, period, nper, pv, fv, pay_type) %}

{% set resultado = pmt(pay_type, pv, fv, rate, nper) - ipmt(rate, period, nper, pv, fv, pay_type) %}

{{return(resultado)}}

{% endmacro %}
