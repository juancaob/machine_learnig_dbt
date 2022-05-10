with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ source('machine_learning_dbt', 'raw_customers') }}

),

stg_customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from source

)

select * from stg_customers
