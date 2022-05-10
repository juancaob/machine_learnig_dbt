{% set creditos = {'credito_1': {'mes_0': {'a': 1, 'b':2, 'c': 3}, 'mes_1': {'a': 1.5, 'b':2.5, 'c': 3.5} }, 'credito_2': {'mes_0': {'a': 4, 'b':5, 'c': 6}, 'mes_1': {'a': 4.5, 'b':5.5, 'c': 6.5}}, 'credito_3': {'mes_0': {'a': 7, 'b':8, 'c': 9}, 'mes_1': {'a': 7.5, 'b':8.5, 'c': 9.5}}} %}

{% for k,v in creditos.items() %}
{% set outer_loop = loop %}

    {% for i in v.values() %}
        {% set lista_mes = v.keys()|list %}
            select {{ "'{}'".format(lista_mes[loop.index-1]) }} as mes,
                   {{ i.a }} as a,
                   {{ i.b }} as b,
                   {{ i.c }} as c
       
       {% if not outer_loop.last %}
          union all 
            {% else %}
            {% if not loop.last %}
            union all
            {% endif%}
       {% endif %}
       
    {% endfor %}

    
{% endfor %}