with promedio as (
    select round(sum(amount)/count(*),2) as monto_total
from {{ ref('stg_payments') }}
)

select * from promedio

{#
select {{ dbt_expectations.log_natural(sum(amount)/count(*)) }} as monto_total
from {{ ref('stg_payments') }}
#}

{#
select {{ dbt_expectations.median('amount')}}
from {{ ref('stg_payments') }}
#}