{% set fruits = ['apple', 'apricot', 'banana'] %}
{% set lista_a = [] %}

{% for fruit in fruits %}

    {% if fruit.startswith('b') %}

        {% do lista_a.append(fruit) %}

    {% endif %}
    
{% endfor %}

{{ lista_a }}
{% set k = fruits|length %}

{{ k }}