create view VD_Customer_evento_info as
select
    customer_key,
    sum(quantity) as total_quantity,
    evento,
    operation
from
transform.dbt_juanjosegr.dateobtains
where evento is not null
group by customer_key, quantity, evento, operation
order by customer_key