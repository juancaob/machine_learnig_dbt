select user_id, count(user_id) as total
from machine_learning_dbt.raw_orders
group by user_id
order by total desc