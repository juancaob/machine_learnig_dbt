{% snapshot orders_snapshot_check %}

{{
    config(
      target_database='airflow-tutorial-336317',
      target_schema='snapshots',
      unique_key='id',

      strategy='check',
      updated_at='updated_at',
      check_cols=['status'],
    )
}}

select * from {{ source('machine_learning_dbt', 'raw_orders_status') }}

{% endsnapshot %}