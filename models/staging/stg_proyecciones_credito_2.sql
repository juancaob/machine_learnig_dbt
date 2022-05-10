{%- set proyeccion_amortizaciones = proyeccion_amortizaciones(credit_id="'67tgdsdfd'", fecha_corte="'2021-04-30'",saldo= 17575689.3, cuota= 235320.5, tasa=0.1475, plazo=210) -%}


{% for key, value in proyeccion_amortizaciones.items() %}

{# select Key: {{key}} as mes #}
select {{value.credit_id}} as credit_id,
       date_add({{value.fecha_corte}}, interval {{loop.index-1}} month) as fecha_pago,
       {{value.saldo}} as credito,
       {{value.cuota}} as cuota,
       {{value.tasa}} as tasa,
       {{value.intereses}} as intereses,
       {{value.amortizacion}} as amortizacion,
       {{value.plazo}} as plazo

    {% if not loop.last -%}
        union all
    {% endif -%}

{% endfor %}
