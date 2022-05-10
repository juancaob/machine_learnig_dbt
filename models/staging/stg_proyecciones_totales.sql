{{ config(materialized='table', clustered_by='credit_id', sort='fecha_pago') }}

{% set query_creditos %}
select credit_id as credit_id,
       fecha_corte as fecha_corte,
       saldo_inicial as saldo,
       cuotas_restantes as plazo,
       tasa as tasa,
       cuota as cuota
from {{ ref('stg_credits') }}
{# limit 3 #}  
{% endset %}

{# Convertir el query a diccionario #}

{%- set creditos = dbt_utils.get_query_results_as_dict(query_creditos) -%}

{# Transformar el diccionario a otro formato para que sea compatible con el macro proyeccion_amortizaciones() #}

{%- set proyecciones_amortizaciones = dict() -%}

{% set rango = creditos['credit_id']|length %}


{% for i in range(rango) %}

        {%- set dicc_cred = { 'credito_{}'.format(i) : {'credit_id': creditos['credit_id'][i],'fecha_corte': creditos['fecha_corte'][i]|string, 'saldo': creditos['saldo'][i]|float, 'plazo': creditos['plazo'][i]|int, 'tasa': creditos['tasa'][i]|float, 'cuota' : creditos['cuota'][i]|float}} -%}
        {% set _dummy = proyecciones_amortizaciones.update(dicc_cred) %} 
        

{% endfor %}

{# Crear una lista con los diccionarios #}
{% set lista_creditos = proyecciones_amortizaciones.values()|list %}

{# Iterar sobre la lista lista_creditos y aplicar a cada diccionario el macro proyeccion_amortizaciones() #}
{% set proyecciones_totales = dict() %}

{% if execute %} 
     {% for i in lista_creditos %}
       {% set proyeccion_amortizaciones_credito = {'credito_{}'.format(loop.index):proyeccion_amortizaciones(**i)} %} 
       {% set _dummy = proyecciones_totales.update(proyeccion_amortizaciones_credito) %} 
     {% endfor %}
{% else %}  
     {% set proyeccion_amortizaciones = [] %} 
{% endif %}

{# Realizar el query final del modelo #}

{% for k,v in proyecciones_totales.items() %}
{% set outer_loop = loop %}

    {% for value in v.values() %}
    {% set lista_mes = v.keys()|list %}
            select {{ "'{}'".format(value.credit_id) }} as credit_id,
                   {{ "'{}'".format(lista_mes[loop.index-1]) }} as mes,
                   date_add({{ "'{}'".format(value.fecha_corte) }}, interval {{ loop.index-1 }} month) as fecha_pago,
                   {{ value.saldo }} as saldo,
                   {{ value.cuota }} as cuota,
                   {{ value.tasa }} as tasa,
                   {{ value.intereses }} as intereses,
                   {{ value.amortizacion }} as amortizacion,
                   {{ value.plazo }} as plazo
       
       {% if not outer_loop.last %}
          union all 
            {% else %}
            {% if not loop.last %}
            union all
            {% endif%}
       {% endif %}
       
    {% endfor %}

    
{% endfor %}