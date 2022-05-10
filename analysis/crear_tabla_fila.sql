{% set num1 = 3 %}
{% set num2 = 4 %}
{% set limite = 6 %}

with numbers as (
  {{ dbt_utils.generate_series(upper_bound=10) }}  
)

select generated_number as period,
       {{ cents_to_dollars('generated_number') }} as cents,
       {{ suma(num1, 'generated_number') }} as suma,
       {{ resta(num2, 'generated_number') }} as resta,
from numbers