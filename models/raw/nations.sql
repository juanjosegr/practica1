{{ config(materialized='table') }}

with nations as (
    select 
        * 
    from 
        raw.tpch_sf1.nation
)
select 
    n.N_NATIONKEY as nation_key,
    n.n_name as nation_name,
    n.n_regionkey as region_key,
from
    nations n
order by
    nation_key