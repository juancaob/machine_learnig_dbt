with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ source('machine_learning_dbt','raw_orders') }}

),

stg_orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from source

)

select * from stg_orders