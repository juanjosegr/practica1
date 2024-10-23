create view VD_Shop_information as
select 
    customer_key, order_key, part_key, operation, quantity, shop_price, shop_hours, id_plazo_entrega
from 
    transform.dbt_juanjosegr.dateobtains
order by customer_key, order_key
