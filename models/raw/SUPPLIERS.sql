{{ config(materialized='table') }}

with SUPPLIERS as (
    select 
        * 
    from 
        raw.tpch_sf1.SUPPLIER
)
select 
    S.S_SUPPKEY as supp_key,
    substr(S.S_NAME,10) as supp_name,
    S.S_ADDRESS as supp_address,
    S.S_NATIONKEY as nation_key,
    S.S_PHONE AS supp_phone
from
    SUPPLIERS S
