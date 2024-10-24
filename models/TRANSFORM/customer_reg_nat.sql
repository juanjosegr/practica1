{{ config(materialized='table') }}

with v1 as(
 select 
        c.CUSTOMER_KEY as customer_key,
        c.nation_key as customer_nation,
        r.region_key as customer_region,
        n.nation_key as nation_key,
        o.order_key as order_key
    from
        raw.dbt_juanjosegr.orders o
    join  
        raw.DBT_JUANJOSEGR.customers c on
        o.customer_key = c.customer_key
    left join
        raw.DBT_JUANJOSEGR.nations n on
        c.NATION_KEY = n.NATION_KEY
    join
        raw.DBT_JUANJOSEGR.regions r on
        n.REGION_KEY = r.REGION_KEY
    group by
        c.CUSTOMER_KEY, c.NATION_KEY, r.region_key, n.nation_key ,o.order_key
    order by
        c.CUSTOMER_KEY
)
select
    v1.customer_key,
    v1.customer_nation,
    v1.customer_region
from v1
group by v1.customer_key,v1.customer_nation,v1.customer_region
order by v1.customer_key