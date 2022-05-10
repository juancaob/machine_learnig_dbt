{#

WITH
  Pass0 as (select 1 as C union all select 1), --2 rows
  Pass1 as (select 1 as C from Pass0 as A, Pass0 as B),--4 rows
  Pass2 as (select 1 as C from Pass1 as A, Pass1 as B),--16 rows
  Pass3 as (select 1 as C from Pass2 as A, Pass2 as B),--256 rows
  Pass4 as (select 1 as C from Pass3 as A, Pass3 as B),--65536 rows
  Tally as (select row_number() over(order by C) as Number, * from Pass4)
 select Number from Tally where Number <= 1000000


WITH
Nbrs_3( n ) AS ( SELECT 1 UNION SELECT 0 ),
Nbrs_2( n ) AS ( SELECT 1 FROM Nbrs_3 n1 CROSS JOIN Nbrs_3 n2 ),
Nbrs_1( n ) AS ( SELECT 1 FROM Nbrs_2 n1 CROSS JOIN Nbrs_2 n2 ),
Nbrs_0( n ) AS ( SELECT 1 FROM Nbrs_1 n1 CROSS JOIN Nbrs_1 n2 ),
Nbrs ( n ) AS ( SELECT 1 FROM Nbrs_0 n1 CROSS JOIN Nbrs_0 n2 )
Tally as ( SELECT ROW_NUMBER() OVER (ORDER BY n from Nbrs) )
SELECT n as 
 FROM ( )
           FROM Nbrs ) D( n )


WITH
  Pass3 AS ( SELECT 1 union all SELECT 0 ),
  Pass2 AS ( SELECT 1 FROM Pass3 n1 CROSS JOIN Pass3 n2 ),
  Pass1 AS ( SELECT 1 FROM Pass2 n1 CROSS JOIN Pass2 n2 ),
  Pass0 AS ( SELECT 1 FROM Pass1 n1 CROSS JOIN Pass1 n2 ),
  Pass AS ( SELECT 1 FROM Pass0 n1 CROSS JOIN Pass0 n2 )
SELECT * 
FROM Pass

#}

WITH number as (
{{ dbt_utils.generate_series(upper_bound=10) }}
)
select generated_number as Number
from number


 