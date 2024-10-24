create view vd_sell_days as
select 
    orderdate as Fecha_pedido,
    count (distinct order_key) as Total_pedido,
    sum(quantity) as cantidad,
    sum(price) as precio
from
transform.dbt_juanjosegr.dateobtains
where operation = 'Sold'
group by orderdate
order by fecha_pedido