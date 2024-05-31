
/*
    Welcome to your first dbt model!
    Did you know that you can also configure models directly within SQL files?
    This will override configurations stated in dbt_project.yml

    Try changing "table" to "view" below
*/

-- decla var

{{ config(materialized='table') }}

With coucou as (
    select test
    from 1
),

source_data as (

    select 1235 as id
    union all
    select null as id
    union all
    select id_part, 
           id_part_part
    union all
    select id_part, idpart_part
    union all 
    select id_part , idpart,part

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
