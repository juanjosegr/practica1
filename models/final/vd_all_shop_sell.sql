create view vd_all_shop_sell as
select 
    shop_key,
    count (distinct order_key) as Total_pedido,
    sum(quantity) as cantidad,
    sum(price) as precio
from
transform.dbt_juanjosegr.dateobtains
where operation = 'Sold'
group by shop_key
order by shop_key