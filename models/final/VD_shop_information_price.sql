create view VD_shop_information_price as
select 
    customer_key, 
    order_key, 
    part_key,
    sum(quantity) as total_quantity,
    operation,
    (sum(cast(substr(shop_price, 1, length(shop_price) -4)as decimal(20,2)))) as shop_price, 
    substr(shop_price, length(shop_price) -2, 3) as currency, 
    id_plazo_entrega,
    evento
from 
    transform.dbt_juanjosegr.dateobtains
group by customer_key, order_key, part_key, quantity, id_plazo_entrega, currency, operation, evento
order by customer_key, order_key