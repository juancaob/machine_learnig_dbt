with source as (
    
    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ source('machine_learning_dbt','raw_stripe_payments') }}

),

stg_payments as (

    select
        id as payment_id,
        orderid as order_id,
        paymentmethod as payment_method,
        status as status,
        --`amount` is currently stored in cents, so we convert it to dollars
        amount / 100 as amount,
        created as created_at

    from source

)

select * from stg_payments
