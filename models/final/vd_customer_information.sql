create view VD_Customer_information as
select 
    customer_key, order_key, part_key, quantity, customer_price, customer_hours, id_plazo_entrega
from 
    transform.dbt_juanjosegr.dateobtains
order by customer_key, order_key