with
    v1 as (
        select
            c.customer_key,
            l.order_key,
            p.part_key,
            p.part_name,
            case
                when l.operation = 'N'
                then 'Sold'
                when l.operation = 'R'
                then 'Return'
                else '-'
            end as operation,
            l.quantity,
            l.price,
            round(l.price * cr.rate_currency, 2)
            || ' '
            || cr.currency as customer_price,
            o.order_date || ' 00:00:00' as orderdate,
            dateadd(hour, cr.utc_hour_conver, orderdate) as customer_hours,
            case
                when datediff('day', l.receiptdate, l.commitdate) > 10
                then '0'  -- Fuera de plazo, el pedido se ha entregado con un retraso mayor a 10 días
                when datediff('day', l.receiptdate, l.commitdate) <= 0
                then '1'  -- En plazo, el pedido se ha entregado como muy tarde en la fecha estimada
                when datediff('day', l.receiptdate, l.commitdate) <= 10
                then '2'  -- Entrega tardía, el pedido se ha entregado como mucho 10 días después de la fecha estimada
            end as id_plazo_entrega,
            o.id_evento,
            e.e_desc
        from orders o
        right join lineitems l on o.order_key = l.order_key
        join parts p on l.part_key = p.part_key
        right join customers c on o.customer_key = c.customer_key
        join nations n on c.nation_key = n.nation_key
        join regions r on n.region_key = r.region_key
        join converion_rates cr on n.nation_key = cr.nation_key
        join suppliers sp on n.nation_key = sp.nation_key
        join shops sh on n.nation_key = sh.nation_key
        left join events e on o.id_evento = e.id_event
        where l.operation != 'A'
        group by
            o.order_date,
            c.customer_key,
            l.order_key,
            p.part_name,
            l.quantity,
            l.price,
            p.part_key,
            l.operation,
            r.region_key,
            cr.rate_currency,
            cr.currency,
            l.receiptdate,
            l.commitdate,
            c.nation_key,
            cr.utc_hour_conver,
            o.id_evento,
            e.e_desc
        order by c.customer_key, o.order_date, p.part_key
    ),
    v2 as (
        select
            l.order_key,
            round((l.price * cr.rate_currency), 2) || ' ' || cr.currency as shop_price,
            o.order_date || ' 00:00:00' as orderdate,
            dateadd(hour, cr.utc_hour_conver, orderdate) as shop_hours
        from lineitems l
        join orders o on l.order_key = o.order_key
        join shops sh on o.shop_key = sh.shop_key
        join nations n on sh.nation_key = n.nation_key
        join converion_rates cr on n.nation_key = cr.nation_key
        group by
            l.order_key,
            l.price,
            cr.rate_currency,
            cr.currency,
            o.order_date,
            cr.utc_hour_conver
        order by l.order_key
    )
select
    v1.customer_key,
    v1.order_key,
    v1.part_key,
    v1.part_name,
    v1.operation,
    v1.quantity,
    v1.price,
    v1.customer_price,
    v2.shop_price,
    v1.orderdate,
    v1.customer_hours,
    v2.shop_hours,
    v1.id_plazo_entrega,
    v1.id_evento,
    v1.e_desc
from v1
join v2 on v1.order_key = v2.order_key
group by
    v1.customer_key,
    v1.order_key,
    v1.part_key,
    v1.part_name,
    v1.operation,
    v1.quantity,
    v1.price,
    v1.customer_price,
    v2.shop_price,
    v1.orderdate,
    v1.customer_hours,
    v2.shop_hours,
    v1.id_plazo_entrega,
    v1.id_evento,
    v1.e_desc
order by v1.customer_key
