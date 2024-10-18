{{ config(materialized='table') }}

with partsupps as (
    select 
        * 
    from 
        raw.tpch_sf1.partsupp
)
select 
    p.PS_PARTKEY as part_key,
    p.PS_SUPPKEY as supp_key,
    p.PS_AVAILQTY as available_qty,
    p.PS_SUPPLYCOST as supply_cost
from
    partsupps p
order by
    part_key