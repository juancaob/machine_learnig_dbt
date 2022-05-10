with prueba as (
    select * from {{ ref('stg_credits') }}
)

select fecha_corte,

       {{ suma('saldo_inicial', 'cuota') }} as creditos
from prueba