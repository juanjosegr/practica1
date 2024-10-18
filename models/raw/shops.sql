{{ config(materialized='table') }}

with SHOPs as (
    select 
        * 
    from 
        raw.tpch_sf1.SHOP
)
select 
    SP_SHOPKEY as shop_key,
    SP_NAME as shop_name,
    SP_NATIONKEY as nation_key
from
    SHOPs 