{% set query_creditos %}
select credit_id as credit_id,
       fecha_corte as fecha_corte,
       saldo_inicial as saldo,
       cuotas_restantes as plazo,
       tasa as tasa,
       cuota as cuota
from {{ ref('stg_credits') }}
limit 3  
{% endset %}

{%- set creditos = dbt_utils.get_query_results_as_dict(query_creditos) -%}



{%- set proyecciones_amortizaciones = dict() -%}

{% set rango = creditos['credit_id']|length %}


{% for i in range(rango) %}

        {%- set dicc_cred = { 'credito_{}'.format(i) : {'credit_id': creditos['credit_id'][i],'fecha_corte': creditos['fecha_corte'][i], 'saldo': creditos['saldo'][i]|float, 'plazo': creditos['plazo'][i]|int, 'tasa': creditos['tasa'][i]|float, 'cuota' : creditos['cuota'][i]|float}} -%}
        {% set _dummy = proyecciones_amortizaciones.update(dicc_cred) %} 
        

{% endfor %}

{% set lista_creditos = proyecciones_amortizaciones.values()|list %}

{% set proyecciones_totales = dict() %}

{% if execute %} 
     {% for i in lista_creditos %}
       {% set proyeccion_amortizaciones_credito = {'credito_{}'.format(loop.index):proyeccion_amortizaciones_json(**i)} %} 
       {% set _dummy = proyecciones_totales.update(proyeccion_amortizaciones_credito) %} 
     {% endfor %}
{% else %}  
     {% set proyeccion_amortizaciones = [] %} 
{% endif %}


{% for k,v in proyecciones_totales.items() %}

select {{ "'{}'".format(k) }} as credito,
       {{ "{}".format(v) }}  as proyeccion
    {% if not loop.last -%}
        union all 
    {% endif %}

{% endfor %}




