{{ config(materialized='table') }}

with v1 as(
    select 
        c.CUSTOMER_KEY,
        l.ORDER_KEY,
        p.PART_KEY,
        p.PART_NAME,
        case 
            when l.OPERATION = 'N' then 'Sold' 
            when l.OPERATION = 'R' then 'Return' 
            else '-' 
        end as Operation,
        l.QUANTITY,
        l.PRICE,
        round(l.PRICE * cr.RATE_CURRENCY,2) || ' ' || cr.currency as customer_price,
        o.ORDER_DATE || ' 00:00:00'  as orderDate,
        dateadd (hour, cr.UTC_HOUR_CONVER, orderDate ) as customer_hours,
        case 
            when datediff('day', l.RECEIPTDATE, l.COMMITDATE) > 10 then '0' -- Fuera de plazo, el pedido se ha entregado con un retraso mayor a 10 días
            when datediff('day', l.RECEIPTDATE, L.COMMITDATE) <= 0 then '1'-- En plazo, el pedido se ha entregado como muy tarde en la fecha estimada
            when datediff('day', l.RECEIPTDATE, L.COMMITDATE) <= 10 then '2'--Entrega tardía, el pedido se ha entregado como mucho 10 días después de la fecha estimada
        end as ID_PLAZO_ENTREGA,
        e.desc as evento,
        c.nation_key as nation,
        r.region_key as region
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
        raw.DBT_JUANJOSEGR.nations n on
        c.NATION_KEY = n.NATION_KEY
    join
        raw.DBT_JUANJOSEGR.regions r on
        n.REGION_KEY = r.REGION_KEY
    join
        raw.DBT_JUANJOSEGR.converion_rates cr on
        n.NATION_KEY = cr.NATION_KEY
    join
        raw.DBT_JUANJOSEGR.SUPPLIERS sp on
        n.nation_key = sp.nation_key
    join 
        raw.DBT_JUANJOSEGR.shops sh on
        n.nation_key = sh.nation_key
    left join 
        raw.DBT_JUANJOSEGR.events e on
        month(o.order_date) between 
        month (e.fecha_inicio) and month(e.fecha_fin) and
        day(o.order_date) between
        day(e.fecha_inicio) and day(e.fecha_fin)
    where 
        l.OPERATION != 'A'
    group by
        o.ORDER_DATE, c.CUSTOMER_KEY, l.ORDER_KEY,  p.PART_NAME, l.QUANTITY, l.PRICE, p.PART_KEY, l.OPERATION, r.REGION_KEY, cr.RATE_CURRENCY, CR.CURRENCY, l.RECEIPTDATE, L.COMMITDATE, c.NATION_KEY, cr.UTC_HOUR_CONVER, e.desc, r.region_key
    order by
        c.CUSTOMER_KEY,o.ORDER_DATE,  p.PART_KEY
), v2 as(
    select
        l.order_key,
        sh.shop_key,
        round((l.price * cr.rate_currency),2) || ' ' || cr.currency as shop_price,
        o.ORDER_DATE || ' 00:00:00'  as orderDate,
        dateadd (hour, cr.UTC_HOUR_CONVER, orderDate ) as shop_hours
    from
        raw.DBT_JUANJOSEGR.lineitems l
    join
        raw.DBT_JUANJOSEGR.orders o on
        l.order_key = o.order_key
    join
        raw.DBT_JUANJOSEGR.shops sh on
        o.shop_key = sh.shop_key
    join 
        raw.DBT_JUANJOSEGR.nations n on
        sh.nation_key = n.nation_key
    join
        raw.DBT_JUANJOSEGR.converion_rates cr on
        n.nation_key = cr.nation_key
    group by l.order_key, l.price, cr.rate_currency, cr.currency, o.ORDER_DATE, cr.UTC_HOUR_CONVER, sh.shop_key
    order by l.order_key
)
select
    v1.CUSTOMER_KEY,
    v2.shop_key,
    v1.ORDER_KEY,
    v1.PART_KEY,
    v1.PART_NAME,
    v1.Operation,
    v1.QUANTITY,
    v1.PRICE,
    v1.customer_price,
    v2.shop_price,
    v1.orderDate,
    v1.customer_hours,
    v2.shop_hours,
    v1.ID_PLAZO_ENTREGA,
    v1.evento,
from 
    v1
join v2 on
    v1.order_key = v2.order_key
group by v1.CUSTOMER_KEY, v1.ORDER_KEY, v1.PART_KEY, v1.PART_NAME, v1.Operation, v1.QUANTITY, v1.PRICE, v1.customer_price, v2.shop_price, v1.orderDate, v1.customer_hours, v2.shop_hours, v1.ID_PLAZO_ENTREGA,      v1.evento , v2.shop_key
order by v1.customer_key