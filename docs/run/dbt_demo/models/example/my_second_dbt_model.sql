
  create or replace   view DBT_DEMO.PUBLIC.my_second_dbt_model
  
   as (
    -- Use the `ref` function to select from other models

select *
from DBT_DEMO.PUBLIC.my_first_dbt_model
where id = 1
  );

