{{ config(materialized='table') }}
select
r.region_key,
r.region_name,
n.nation_key,
n.nation_name
from
raw.dbt_juanjosegr.nations n
join
raw.dbt_juanjosegr.regions r on
n.region_key = r.region_key
order by r.region_key