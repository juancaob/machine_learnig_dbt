{% macro proyeccion_amortizaciones_json(credit_id, fecha_corte, saldo, cuota, tasa, plazo) %}

{%- set condiciones_credito = dict(credit_id=credit_id, fecha_corte=fecha_corte, saldo=saldo , cuota=cuota, tasa=tasa, plazo=plazo) -%}
{%- set proyeccion_amortizaciones = dict() -%}

{%- for i in range(condiciones_credito['plazo']) -%}

    {%- if i == 0 -%}
        {%- set intereses = saldo*tasa/12 -%}
        {%- set amortizacion =  cuota - intereses -%}
        {%- set diccionario_resultados = { "mes_{}".format(i) : {"credit_id": credit_id, "fecha_corte": fecha_corte|string, "saldo": saldo|round(1), "cuota": cuota, "tasa": tasa, "intereses" : intereses|round(1), "amortizacion": amortizacion|round(1), "plazo": plazo}} -%}
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}

    {%- else -%}
        {% set k = proyeccion_amortizaciones|length %}
        {% set saldo = proyeccion_amortizaciones["mes_{}".format(k-1)]["saldo"] - proyeccion_amortizaciones["mes_{}".format(k-1)]["amortizacion"] %}
        {% set cuota = proyeccion_amortizaciones["mes_{}".format(k-1)]["cuota"] %}
        {% set tasa = proyeccion_amortizaciones["mes_{}".format(k-1)]["tasa"] %}
        {% set intereses = saldo*tasa/12 %}
        {% set amortizacion =  cuota - intereses %}
        {%- set diccionario_resultados = { "mes_{}".format(i) : {"credit_id": credit_id, "fecha_corte": fecha_corte|string, "saldo": saldo|round(1), "cuota": cuota, "tasa": tasa, "intereses" : intereses|round(1), "amortizacion": amortizacion|round(1), "plazo": plazo}} -%} 
        {% set _dummy = proyeccion_amortizaciones.update(diccionario_resultados) %}
    {% endif %}
    
{% endfor %}

{{ return(proyeccion_amortizaciones|string|tojson)}}
    
{% endmacro %}