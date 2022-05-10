{{config(
	materialized = 'table',
	partition_by = { 'field': 'fecha_corte', 'granularity': "month"},
    
)}}

with source as (

    {#-
    Normally we would select from the table here, but we are using seeds to load
    our data in this project
    #}
    select * from {{ source('machine_learning_dbt', 'raw_credits_abril') }}

),

stg_credits as (
    select {{ dbt_utils.surrogate_key(['fecha_finaliza', 'Cuota']) }} as credit_id,
           current_timestamp as created_at,
           Fecha_de_corte as fecha_corte,
           Fecha_Finaliza as fecha_finaliza,
           date_diff(Fecha_Finaliza, Fecha_de_corte, month) as cuotas_restantes,
           round(cast(replace(regexp_replace(Saldo_Inicial,'[₡.]',''), ',', '.') as float64), 1) as saldo_inicial,
           Tasa_Interes/100 as tasa,
           Plazo_en_meses as plazo,
           round(cast(replace(regexp_replace(Cuota,'[₡.]',''), ',', '.') as float64), 1) as cuota,
           Tipo_Cr__dito as tipo_credito,
           Garant__a as garantia,
           Categor__a_Riesgo as categoria_riesgo,
           Estado as estado
    from source

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run if the original data has not an date column
  where current_timestamp >= (select max(current_timestamp) from {{ this }})

{% endif %}
)

select * from stg_credits

