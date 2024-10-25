create table order_date as
select
    ORDER_KEY,
    PART_KEY,
    PART_NAME,
    OPERATION,
    QUANTITY,
    PRICE,
    ORDERDATE,
    EVENTO,
    ID_PLAZO_ENTREGA
from
    dateobtains