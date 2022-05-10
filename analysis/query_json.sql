{#
select cast(proyeccion as struct)
from {{ ref('stg_proyecciones_totales') }}
where credito = 'credito_1'


select
  credito, 
  json_extract_array(proyeccion) as proyecciones_totales
from {{ ref('stg_proyecciones_totales_2') }}


SELECT
  JSON_EXTRACT('{"class":{"students":[{"id":5},{"id":12}]}}', '$.class.students')
  AS json_data;



{% set par= { 'mes_{}'.format(1): "{}".format('credito')} %}

{{ par }}



select
  clase, 
  json_query(info, '$.class') as clase
from {{ ref('prueba_json') }}

#}

select
  credito, 
  json_query(proyeccion, '$.mes_0') as mes_2
from {{ ref('stg_proy_totales__json') }}

{#
SELECT JSON_QUERY_ARRAY( proyeccion,'$.credito'
  ) AS json_array
#}

