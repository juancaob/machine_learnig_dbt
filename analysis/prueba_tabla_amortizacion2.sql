{% set pv_0 = -1000000 %}
{% set fv = 0 %}
{% set nper = 15*26 %}
{% set pay_type = 0 %}
{% set tasa = 0.07/26 %}
{% set fecha='2010-01-21' %}
{% set pmt = -pmt(pay_type, pv_0, fv, tasa, nper) %}


{% for i in range(nper) %}
{% set period = loop.index %}
select {{ period }} as  period,
       date_add({{ "'{}'".format(fecha) }}, interval {{ period-1 }} week) as fecha_pago,
       round(-1*({{ pv(pay_type, pmt, fv, tasa, nper-(period-1)) }}), 1) as saldo_inicial,
       round( {{ pmt }}, 1) as cuota,
       round( -1*({{ ipmt(tasa, period, nper, pv_0, fv, pay_type) }}), 1) as pago_intereses,
       round( -1*({{ ppmt(tasa, period, nper, pv_0, fv, pay_type) }}), 1) as pago_principal,
       round(-1*({{ pv(pay_type, pmt, fv, tasa, nper-period) }}), 1) as balance_final
    
    {% if not loop.last -%}
        union all
    {% endif -%}
{% endfor %}
