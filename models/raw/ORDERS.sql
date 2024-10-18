{{ config(materialized='table') }}

with ORDERS as (
    select 
        * 
    from 
        raw.tpch_sf1.ORDERS
)
select
    o.o_orderkey as order_key,
    o.O_CUSTKEY as CUSTOMER_KEY,
    o.O_TOTALPRICE as TOTAL_PRICE,
    o.O_ORDERDATE as ORDER_DATE ,
    substr(o.O_ORDERPRIORITY,0,1) as PRIORITY,
    substr(o.O_CLERK,7) as CLERK,
    o.O_SHOPKEY as SHOP_KEY
from
    ORDERS o