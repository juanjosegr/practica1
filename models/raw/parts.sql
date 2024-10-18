{{ config(materialized='table') }}

with parts as (
    select 
        * 
    from 
        raw.tpch_sf1.part
)
select 
    p.p_partkey as part_key,
    p.p_name as part_name,
    substr(p.p_mfgr,14) as Manufacturer,
    substr(p.p_brand,7) as brand,
    p.P_RETAILPRICE as reatilPrice 
from
    parts p
order by
    part_key