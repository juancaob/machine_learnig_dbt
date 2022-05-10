{%- set condiciones_credito={'credit_id': "'67tgdsdfd'", 'fecha_corte': "'2021-04-30'", 'saldo': 17575689.3, 'cuota': 235320.5, 'tasa': 0.1475, 'plazo': 210} -%}
{%- set proyeccion_amortizaciones = dict() -%}

{%- for i in range(condiciones_credito['plazo']) -%}

    {%- if i == 0 -%}
        {%- set credit_id = condiciones_credito['credit_id'] -%}
        {%- set saldo = condiciones_credito['saldo'] -%}
        {%- set cuota = condiciones_credito['cuota'] -%}
        {%- set tasa = condiciones_credito['tasa'] -%}
        {%- set intereses = saldo*tasa/12 -%}
        {%- set amortizacion =  cuota - intereses -%}
        {%- set plazo =  condiciones_credito['plazo'] -%}
        {%- set diccionario_resultados = { 'mes_{}'.format(i) : {'credit_id': credit_id,'saldo': saldo|round(1), 'cuota': cuota, 'tasa': tasa, 'intereses' : intereses|round(1), 'amortizacion': amortizacion|round(1), 'plazo': plazo}} -%}
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}
        {# {% do proyeccion_amortizaciones.append([saldo, cuota, tasa, intereses|round(1), amortizacion|round(1)]) %} #}

    {%- else -%}
        {%- set credit_id = condiciones_credito['credit_id'] -%}
        {% set k = proyeccion_amortizaciones|length %}
        {% set saldo = proyeccion_amortizaciones['mes_{}'.format(k-1)]['saldo'] - proyeccion_amortizaciones['mes_{}'.format(k-1)]['amortizacion'] %}
        {% set cuota = proyeccion_amortizaciones['mes_{}'.format(k-1)]['cuota'] %}
        {% set tasa = proyeccion_amortizaciones['mes_{}'.format(k-1)]['tasa'] %}
        {% set intereses = saldo*tasa/12 %}
        {% set amortizacion =  cuota - intereses %}
        {%- set plazo =  condiciones_credito['plazo'] -%}
        {%- set diccionario_resultados = { 'mes_{}'.format(i) : {'credit_id': credit_id, 'saldo': saldo|round(1), 'cuota': cuota, 'tasa': tasa, 'intereses' : intereses|round(1), 'amortizacion': amortizacion|round(1), 'plazo': plazo}} -%}
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}
        {# {% do proyeccion_amortizaciones.append([saldo, cuota, tasa, intereses|round(1), amortizacion|round(1)]) %} #}
    {% endif %}
    
{% endfor %}

{% for key, value in proyeccion_amortizaciones.items() %}

{# select Key: {{key}} as mes #}
select {{value.credit_id}} as credit_id,
       date_add({{condiciones_credito['fecha_corte']}}, interval {{loop.index-1}} month) as fecha_pago,
       {{value.saldo}} as credito,
       {{value.cuota}} as cuota,
       {{value.tasa}} as tasa,
       {{value.intereses}} as intereses,
       {{value.amortizacion}} as amortizacion,
       {{value.plazo}} as plazo

    {% if not loop.last -%}
        union all
    {% endif -%}

{% endfor %}