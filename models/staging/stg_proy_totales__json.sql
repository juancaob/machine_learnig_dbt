select credito,
       regexp_replace(proyeccion,"'",'"')  as proyeccion
from {{ ref('stg_proy_totales_json') }}