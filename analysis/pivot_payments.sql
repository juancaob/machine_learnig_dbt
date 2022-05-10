select
  order_id,
  {{ dbt_utils.pivot(
      'payment_method',
      dbt_utils.get_column_values(ref('stg_payments'), 'payment_method'),
      then_value = 'amount'
  ) }}
from {{ ref('stg_payments') }}
group by order_id
order by order_id