create view VD_Customer_information_price as
select 
    customer_key, 
    order_key, 
    part_key,
    sum(quantity) as total_quantity,
    operation,
    (sum(cast(substr(customer_price, 0, length(customer_price) -4)as decimal(20,2)))) as customer_price, 
    substr(customer_price, length(customer_price) -2, 3) as currency, 
    id_plazo_entrega,
    evento
from 
    transform.dbt_juanjosegr.dateobtains
group by customer_key, order_key, part_key, quantity, id_plazo_entrega, currency, operation, evento
order by customer_key, order_key