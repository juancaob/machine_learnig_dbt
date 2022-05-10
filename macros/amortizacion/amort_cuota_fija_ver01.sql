{% macro amortizacion_cuota_fija_ver01(pv_0, fv_0, cuota, termino, tasa_anual, cantidad_pagos, tipo_pago, fecha_inicial) %}
{% set tasa=tasa_anual/12*cantidad_pagos %}
{% set nper=termino*cantidad_pagos %}

{% for i in range(nper) %}
{% set period = loop.index %}
select {{ period }} as  period,
       date_add({{ "'{}'".format(fecha_inicial) }}, interval {{ period-1 }} month) as fecha_pago,
       round(-1*({{ pv(tipo_pago, cuota, fv_0, tasa, nper-(period-1)) }}), 1) as saldo_inicial,
       round( {{ cuota }}, 1) as cuota,
       round( -1*({{ ipmt(tasa, period, nper, pv_0, fv_0, tipo_pago) }}), 1) as pago_intereses,
       round( -1*({{ ppmt(tasa, period, nper, pv_0, fv_0, tipo_pago) }}), 1) as pago_principal,
       round(-1*({{ pv(tipo_pago, cuota, fv_0, tasa, nper-period) }}), 1) as balance_final
    
    {% if not loop.last -%}
        union all
    {% endif -%}
{% endfor %}
    
{% endmacro %}