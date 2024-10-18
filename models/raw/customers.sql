with customers as (
    select * from raw.tpch_sf1.customer
)
select 
    c.c_custkey as customer_key,
    c.c_name as customer_name,
    c.c_address as customer_address,
    c.c_nationkey as nation_key,
    c.c_phone as customer_phone,
from
    customers c
order by
    c.c_custkey