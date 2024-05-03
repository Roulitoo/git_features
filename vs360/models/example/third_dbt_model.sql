select id as new_id,
       id+1 as new_cc,
       id+2 as new_part
from {{ ref('my_first_dbt_model') }}
where id = 1 or id = 2
