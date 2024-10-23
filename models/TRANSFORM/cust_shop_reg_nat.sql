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
),v2 as(
    select 
        sh.shop_name,
        sh.nation_key shop_nation,
        sh.shop_key,
        r.region_key as shop_region,
        n.nation_key as nation_key,
         o.order_key as order_key
    from
        raw.dbt_juanjosegr.orders o
    join  
        raw.DBT_JUANJOSEGR.customers c on
        o.customer_key = c.customer_key
    join
        raw.DBT_JUANJOSEGR.shops sh on
        o.shop_key = sh.shop_key
    join
        raw.DBT_JUANJOSEGR.nations n on
        sh.nation_key = n.NATION_KEY
    join
        raw.DBT_JUANJOSEGR.regions r on
        n.REGION_KEY = r.REGION_KEY
    group by
         sh.shop_name, sh.nation_key, r.region_key , n.nation_key , o.order_key, sh.shop_key
)
select
    v1.customer_key,
    v1.customer_nation,
    v1.customer_region,
    v2.shop_key,
    v2.shop_nation,
    v2.shop_region
from v1
join v2 on
    v1.order_key = v2.order_key
group by v1.customer_key,v1.customer_nation,v1.customer_region,v2.shop_name,v2.shop_nation,v2.shop_region, v2.shop_key
order by v1.customer_key