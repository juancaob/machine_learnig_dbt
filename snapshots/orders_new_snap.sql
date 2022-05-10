{% snapshot orders_snapshot_timestamp %}

{{
    config(
      target_database='airflow-tutorial-336317',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from {{ source('machine_learning_dbt', 'raw_orders_status') }}

{% endsnapshot %}