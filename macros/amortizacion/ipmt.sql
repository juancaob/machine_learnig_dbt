{% macro ipmt(rate, period, nper, pv_0, fv_0, pay_type) %}

{% set payment= -pmt(pay_type, pv_0, fv_0, rate, nper) %}

{# {% set interest=0.0 %} #}
		
{% if period==1 %}

    {% if pay_type==1 %}
        {% set interest=0 %}
    {% else %}
        {% set interest= pv_0 %}
    {% endif %}

{% else %}
 
    {% if pay_type==1 %}
        {% set interest= pv(1, payment, fv_0, rate, nper-(period-1))%} -- correct this formula
    {% else %}        
        {% set interest= pv(0, payment, fv_0, rate, nper-(period-1)) %}  
                         
    {% endif %}

{% endif %}


{{ return(interest*rate) }}

{% endmacro %}

