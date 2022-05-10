{%- set condiciones_credito={'saldo': 17575689.3, 'cuota': 235320.5, 'tasa': 0.1475, 'plazo': 213} -%}
{%- set proyeccion_amortizaciones = dict() -%}

{%- for i in range(condiciones_credito['plazo']) -%}

    {%- if i == 0 -%}
        {%- set saldo = condiciones_credito['saldo'] -%}
        {%- set cuota = condiciones_credito['cuota'] -%}
        {%- set tasa = condiciones_credito['tasa'] -%}
        {%- set intereses = saldo*tasa/12 -%}
        {%- set amortizacion =  cuota - intereses -%}
        {%- set diccionario_resultados = { 'mes_{}'.format(i) : {'saldo': saldo|round(1), 'cuota': cuota, 'tasa': tasa, 'intereses' : intereses|round(1), 'amortizacion': amortizacion|round(1)}} -%}
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}
        {# {% do proyeccion_amortizaciones.append([saldo, cuota, tasa, intereses|round(1), amortizacion|round(1)]) %} #}

    {%- else -%}
        {% set k = proyeccion_amortizaciones|length %}
        {% set saldo = proyeccion_amortizaciones['mes_{}'.format(k-1)]['saldo'] - proyeccion_amortizaciones['mes_{}'.format(k-1)]['amortizacion'] %}
        {% set cuota = proyeccion_amortizaciones['mes_{}'.format(k-1)]['cuota'] %}
        {% set tasa = proyeccion_amortizaciones['mes_{}'.format(k-1)]['tasa'] %}
        {% set intereses = saldo*tasa/12 %}
        {% set amortizacion =  cuota - intereses %}
        {%- set diccionario_resultados = { 'mes_{}'.format(i) : {'saldo': saldo|round(1), 'cuota': cuota, 'tasa': tasa, 'intereses' : intereses|round(1), 'amortizacion': amortizacion|round(1)}} -%}
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}
        {# {% do proyeccion_amortizaciones.append([saldo, cuota, tasa, intereses|round(1), amortizacion|round(1)]) %} #}
    {% endif %}
    
{% endfor %}

{% set query_1 %}
    SELECT *
    FROM
    FLATTEN([proyeccion_amortizaciones])
{% endset %}

{% for key, value in proyeccion_amortizaciones.items() %}

{# select Key: {{key}} as mes #}
select {{value.saldo}} as credito,
       {{value.cuota}} as cuota,
       {{value.tasa}} as tasa,
       {{value.intereses}} as intereses,
       {{value.amortizacion}} as amortizacion

    {% if not loop.last -%}
        union all
    {% endif -%}

{% endfor %}