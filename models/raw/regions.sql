{{ config(materialized='table') }}

with regions as (
    select 
        * 
    from 
        raw.tpch_sf1.region
)
select 
    r.R_REGIONKEY as region_key,
    r.R_NAME as region_name
from
    regions r
