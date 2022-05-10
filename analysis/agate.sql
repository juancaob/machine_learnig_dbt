{% set query_creditos %}
select credit_id as credit_id,
       fecha_corte as fecha_corte,
       saldo_inicial as saldo,
       cuotas_restantes as plazo,
       tasa as tasa,
       cuota as cuota
from {{ ref('stg_credits') }}
limit 2  
{% endset %}

{% set query_results = run_query(query_creditos) %}

{% if execute %}
{# Return the first column #}
{% set results = query_results %}
{% else %}
{% set results_1 = [] %}
{% endif %}


select ({{ results.columns['saldo'][0] }} - {{ results.columns['cuota'][0] }}) as resta
    
