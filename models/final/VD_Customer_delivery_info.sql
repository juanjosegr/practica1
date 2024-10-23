create view VD_Customer_delivery_info as
select
    customer_key,
    id_plazo_entrega,
    count(id_plazo_entrega) as total_plazos_entrega
from
    transform.dbt_juanjosegr.dateobtains
group by id_plazo_entrega,customer_key
order by customer_key, id_plazo_entrega