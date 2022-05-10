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

{% set query_results = run_query(query_creditos) %}

{% if execute %}

{% set results = query_results %}
{% set pv_0 = -results.columns['saldo'][2] %}
{% set fv_0 = 0 %}
{% set tipo_pago = 0 %}
{% set tasa_anual = results.columns['tasa'][2] %}
{% set fecha_inicial= "'{}'".format(results.columns['fecha_corte'][2]) %}
{% set cuota = results.columns['cuota'][2] %}
{% set plazo = results.columns['plazo'][2]|int %}
{% set credit_id = "'{}'".format(results.columns['credit_id'][2]) %}
{% set dicc_creditos = {'credit_id': credit_id, 'plazo': plazo, 'fecha_inicial': fecha_inicial, 'tipo_pago': tipo_pago, 'cuota': cuota, 'fv_0': fv_0, 'tasa_anual': tasa_anual, 'pv_0':pv_0} %}
{% set amortizaciones = amortizaciones_cuota_fija(**dicc_creditos) %}
{% else %}
{% set results_1 = [] %}
{% endif %}

{{ amortizaciones }}