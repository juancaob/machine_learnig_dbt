{#
{% macro amortizacion(saldo, cuota, tasa, plazo) %}

{%- set proyeccion_amortizaciones = dict() -%}

{%- for i in range({{plazo}}) -%}

    {%- if i == 0 -%}
        {%- set saldo = condiciones_credito['saldo'] -%}
        {%- set cuota = condiciones_credito['cuota'] -%}
        {%- set tasa = condiciones_credito['tasa'] -%}
        {%- set intereses = saldo*tasa/12 -%}
        {%- set amortizacion =  cuota - intereses -%}
        {%- set diccionario_resultados = { 'mes_{}'.format(i) : {'saldo': saldo|round(1), 'cuota': cuota, 'tasa': tasa, 'intereses' : intereses|round(1), 'amortizacion': amortizacion|round(1)}} -%}
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}

    {%- else -%}
        {% set k = proyeccion_amortizaciones|length %}
        {% set saldo = proyeccion_amortizaciones['mes_{}'.format(k-1)]['saldo'] - proyeccion_amortizaciones['mes_{}'.format(k-1)]['amortizacion'] %}
        {% set cuota = proyeccion_amortizaciones['mes_{}'.format(k-1)]['cuota'] %}
        {% set tasa = proyeccion_amortizaciones['mes_{}'.format(k-1)]['tasa'] %}
        {% set intereses = saldo*tasa/12 %}
        {% set amortizacion =  cuota - intereses %}
        {%- set diccionario_resultados = { 'mes_{}'.format(i) : {'saldo': saldo|round(1), 'cuota': cuota, 'tasa': tasa, 'intereses' : intereses|round(1), 'amortizacion': amortizacion|round(1)}} -%}
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}
    {% endif %}
    
{% endfor %}
    
{% endfor %}
    
{% endmacro %}

#}