create view vd_all_region_sell as
select 
    shop_region,
    count (distinct order_key) as Total_pedido,
    sum(quantity) as cantidad,
    sum(price) as precio
from
transform.dbt_juanjosegr.dateobtains
where operation = 'Sold'
group by shop_region
order by shop_region