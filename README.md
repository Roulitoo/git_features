{% set end_date = '9999-12-31' %}
{% set months_back = 36 %}
{% set date_range = [] %}

-- Create a list of dates for the last 36 months
{% for i in range(0, months_back) %}
    {% set calculated_date = dateadd('month', -i, end_date) | date('YYYY-MM-DD') %}
    {% do date_range.append(calculated_date) %}
{% endfor %}

with faux_client as (

    -- Loop over each date in the date_range
    {% for current_date in date_range %}

    select
        id_part,
        '{{ current_date }}' as snapshot_date
    from {{ ref('stg_contrat') }}
    where dd_histo < '{{ current_date }}'
      and dd_histo = '9999-12-31'
      and cd_natu_lien_prod='021'
    group by id_part
    having sum(prod_elig_client) = 0
    
    {% if not loop.last %}
        union all
    {% endif %}

    {% endfor %}

)

select distinct
    id_part,
    1 as faux_client,
    snapshot_date
from faux_client
