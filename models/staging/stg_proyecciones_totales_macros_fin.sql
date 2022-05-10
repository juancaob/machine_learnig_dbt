{{ config(materialized='table', clustered_by='credit_id', sort='fecha_pago') }}

{% set query_creditos %}
select credit_id as credit_id,
       fecha_corte as fecha_corte,
       saldo_inicial as saldo,
       cuotas_restantes as plazo,
       tasa as tasa,
       cuota as cuota
from {{ ref('stg_credits') }}
limit 4  
{% endset %}

{% set query_results = run_query(query_creditos) %}

{% if execute %}    
{% set results = query_results %}
{% for i in range(results.rows|length) %}
{% set outer_loop = loop %}
    {% for plazo in range(results.columns['plazo'][i]|int) %}
    {% set period = loop.index %}
    {% set nper= results.columns['plazo'][i] %}
    {% set fecha= "'{}'".format(results.columns['fecha_corte'][i])  %}
    {% set pv_0 = -results.columns['saldo'][i] %}
    {% set fv_0 = 0 %}
    {% set tipo_pago = 0 %}
    {% set tasa_anual = results.columns['tasa'][i] %}
    {% set cuota = results.columns['cuota'][i] %}
    {% set credit_id = "'{}'".format(results.columns['credit_id'][i]) %}

        select {{credit_id}} as credit_id,
               {{ period }} as  period,
               date_add({{ fecha }}, interval {{ period-1 }} week) as fecha_pago,
               round(-1*({{ pv(tipo_pago, cuota, fv_0, tasa_anual/12, nper-(period-1)) }}), 1) as saldo_inicial,
               round( {{ cuota }}, 1) as cuota,
               round( -1*({{ ipmt(tasa_anual/12, period, nper, pv_0, fv_0, tipo_pago) }}), 1) as pago_intereses,
               round( -1*({{ ppmt(tasa_anual/12, period, nper, pv_0, fv_0, tipo_pago) }}), 1) as pago_principal,
               round(-1*({{ pv(tipo_pago, cuota, fv_0, tasa_anual/12, nper-period) }}), 1) as balance_final
        {% if not outer_loop.last %}
                    union all 
               {% else %}
                 {% if not loop.last %}
                    union all
               {% endif%}
       {% endif %}

    {% endfor %}
{% endfor %}

{% else %}
{% set results = [] %}
{% endif %}
