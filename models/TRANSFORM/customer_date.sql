create table customer_date as
select
    CUSTOMER_KEY,
    ORDER_KEY,
    QUANTITY,
    CUSTOMER_PRICE,
    CUSTOMER_HOURS,
    CUSTOMER_NATION,
    CUSTOMER_REGION
from
    dateobtains