
-- Use the `ref` function to select from other models

select *,
        8500 as salaire_client
from {{ ref('my_first_dbt_model') }}
where id = 1
