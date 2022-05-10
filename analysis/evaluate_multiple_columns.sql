with orders as (
    select * from {{ ref('stg_orders') }}
)

select order_id,
       case
        when customer_id < 20 and status = 'shipped' then 'joven'
        when customer_id >= 20 and status = 'placed' or status = 'shipped' then 'mayor'
        when status = 'returned' then 'returned'
       end col
from orders