create table shop_date as
select
    SHOP_KEY,
    ORDER_KEY,
    PART_KEY,
    QUANTITY,
    SHOP_PRICE,
    SHOP_HOURS,
    EVENTO,
    SHOP_NATION,
    SHOP_REGION
from
    dateobtains