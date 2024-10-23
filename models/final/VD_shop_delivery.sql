create view VD_shop_delivery as 
select 
shop_key, id_plazo_entrega, count(id_plazo_entrega) as total_plazo
from
transform.dbt_juanjosegr.dateobtains 
group by  shop_key, id_plazo_entrega
order by  shop_key, id_plazo_entrega
