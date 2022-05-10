{% macro amortizaciones_cuota_fija(credit_id, plazo, fecha_inicial, tipo_pago, cuota, fv_0, tasa_anual, pv_0) %}
{% set tasa=tasa_anual/12 %}

{% for i in range(plazo) %}
{% set period = loop.index %}
select {{ credit_id }} as credit_id,
       {{ period }} as  period,
       date_add({{ fecha_inicial }}, interval {{ period-1 }} month) as fecha_pago,
       round(-1*({{ pv(tipo_pago, cuota, fv_0, tasa, plazo-(period-1)) }}), 1) as saldo_inicial,
       round( {{ cuota }}, 1) as cuota,
       round( -1*({{ ipmt(tasa, period, plazo, pv_0, fv_0, tipo_pago) }}), 1) as pago_intereses,
       round( -1*({{ ppmt(tasa, period, plazo, pv_0, fv_0, tipo_pago) }}), 1) as pago_principal,
       round(-1*({{ pv(tipo_pago, cuota, fv_0, tasa, plazo-period) }}), 1) as balance_final
    
    {% if not loop.last -%}
        union all
    {% endif -%}
{% endfor %}

{% endmacro %}