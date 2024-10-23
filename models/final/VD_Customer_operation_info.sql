create view VD_Customer_operation_info as
select
    customer_key,
    operation,
    count(operation) as total_operation
from
    transform.dbt_juanjosegr.dateobtains
group by operation,customer_key
order by customer_key