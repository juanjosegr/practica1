update TRANSFORM.DBT_JUANJOSEGR.dateobtains
set dateobtains.id_plazo_entrega = temp_criteros_nuevo.id_plazo_entrega
from TRANSFORM.DBT_JUANJOSEGR.temp_criteros_nuevo
where dateobtains.customer_key = temp_criteros_nuevo.customer_key
and dateobtains.order_key = temp_criteros_nuevo.order_key
and dateobtains.part_key = temp_criteros_nuevo.part_key