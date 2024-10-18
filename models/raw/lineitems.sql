{{ config(materialized='table') }}

with lineitems as (
    select 
        * 
    from 
        raw.tpch_sf1.lineitem
)
select 
    l.l_orderkey as order_key,
    l.L_PARTKEY as part_key,
    l.L_SUPPKEY as supp_key,
    l.L_LINENUMBER as lineNumber,
    l.L_QUANTITY as quantity,
    l.L_EXTENDEDPRICE as Price,
    l.L_RETURNFLAG as Operation,
    l.L_SHIPDATE as ShipDate,
    l.L_COMMITDATE as CommitDate,
    l.L_RECEIPTDATE as ReceiptDate
from
    lineitems l
order by
   order_key, lineNumber