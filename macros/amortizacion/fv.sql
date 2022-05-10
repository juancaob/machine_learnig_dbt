{% macro fv(pay_type, rate, nper, pmt, pv) %}
{% set term = (1 + rate)**nper %}

{% if pay_type == 0 %}

{% set fv = (((term-1)/rate)*-pmt)+((term)*-pv) %}

{% else %}

{% set fv = ((((1+rate)**(nper+1)-(1+rate)))/rate*-pmt)+((term)*-pv) %}

{% endif %}

{{ return(fv) }}
    
{% endmacro %}


