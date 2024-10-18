{{ config(materialized='table') }}

with CONVERION_RATES as (
    select 
        * 
    from 
        raw.tpch_sf1.CONVERION_RATES
)
select 
    CR_NATIONKEY as nation_key,
    CR_CURRENCY as currency,
    CR_CONVERSION_RATE as rate_currency,
    CR_CONVERSION_HOUR as utc_hour_conver
from
    CONVERION_RATES 
