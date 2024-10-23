select 
    c.CUSTOMER_KEY,
    l.ORDER_KEY,
    p.PART_KEY,
    case 
        when datediff('day', l.RECEIPTDATE, l.COMMITDATE) > 30 then '0' -- Fuera de plazo, el pedido se ha entregado con un retraso mayor a 20 días
        when datediff('day', l.RECEIPTDATE, L.COMMITDATE) = 0 then '1'-- En plazo, el pedido se ha entregado como muy tarde en la fecha estimada
        when datediff('day', l.RECEIPTDATE, L.COMMITDATE) <= 10 then '2'--Entrega tardía, el pedido se ha entregado como mucho 10 días después de la fecha estimada
        when datediff('day', l.receiptdate, l.commitdate) between 10 and 30 then 3 
    end as ID_PLAZO_ENTREGA,
from
    raw.DBT_JUANJOSEGR.orders o
right join 
    raw.DBT_JUANJOSEGR.LINEITEMS l on
    o.ORDER_KEY = l.ORDER_KEY
join 
    raw.DBT_JUANJOSEGR.parts p on
    l.PART_KEY = p.PART_KEY
right join 
    raw.DBT_JUANJOSEGR.customers c on
    o.CUSTOMER_KEY = c.CUSTOMER_KEY
left join 
    raw.DBT_JUANJOSEGR.events e on
    month(o.order_date) between 
    month (e.fecha_inicio) and month(e.fecha_fin) and
    day(o.order_date) between
    day(e.fecha_inicio) and day(e.fecha_fin)
where 
    l.OPERATION != 'A'
group by
    o.ORDER_DATE, c.CUSTOMER_KEY, l.ORDER_KEY,  p.PART_KEY, l.OPERATION, l.RECEIPTDATE, L.COMMITDATE
order by
    c.CUSTOMER_KEY,o.ORDER_DATE,  p.PART_KEY
