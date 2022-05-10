 with prueba as (
     select row_number() over (order by order_id ) as RowNumber , * 
 from {{ ref('stg_payments') }}
 )

select * from prueba
where RowNumber between 3 and 23