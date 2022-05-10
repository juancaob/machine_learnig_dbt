{% set credit_id = '6a4ea68576fab741c82e33cf8737d2f22021' %}
{% set fecha_corte = '2021-04-30' %}
{% set saldo = 17575689.3 %}
{% set plazo =  213 %}
{% set tasa = 0.1475 %}
{% set cuota = 235320.5 %}
{% set pay_type = 0 %}
{% set valor_futuro = fv(tasa, plazo, cuota, saldo, pay_type) %}
{% set period=13 %}


with numbers as (
  {{ dbt_utils.generate_series(upper_bound=210) }}  
)
  
select generated_number as period,
       -1*({{ pv(pay_type, cuota, valor_futuro, tasa, plazo-(period-1)) }}) as saldo_inicial,
       {{ cuota }} as cuota,
       {#
       {{ ipmt(tasa, period, plazo, saldo, valor_futuro, pay_type) }} as pago_intereses,
       {{ ppmt(tasa, period, plazo, saldo, valor_futuro, pay_type) }} as pago_principal,
       -1*({{ pv(pay_type, cuota, valor_futuro, tasa, plazo-period) }}) as balance_final, 
       {{ cents_to_dollars('generated_number') }} as cents,
       {{ suma(num1, 'generated_number') }} as suma,
       {{ resta(num2, 'generated_number') }} as resta
       #}
from numbers