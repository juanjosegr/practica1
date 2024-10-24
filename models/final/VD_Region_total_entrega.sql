create view VD_Region_total_entrega as
select
    shop_region as Region,
    id_plazo_entrega,
    count(id_plazo_entrega) as total_plazos_entrega
from
    transform.dbt_juanjosegr.dateobtains
group by id_plazo_entrega, shop_region
order by  shop_region, id_plazo_entrega