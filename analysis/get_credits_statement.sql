-- depends_on: {{ ref('stg_credits') }}

{% call statement('get_creditos', fetch_result=True,auto_begin=True) %}

select credit_id as credit_id,
       fecha_corte as fecha_corte,
       saldo_inicial as saldo,
       cuotas_restantes as plazo,
       tasa as tasa,
       cuota as cuota
    from {{ ref('stg_credits') }} 
limit 3 

{%- endcall -%}


{%- set creditos = load_result('get_creditos') -%}
{%- set creditos_data = creditos['data'] -%}
{%- set creditos_status = creditos['response'] -%}

select {{ creditos_data[0][3] }} as plazo
