create or replace STREAM custormer_stream
on table raw.dbt_juanjosegr.customers
APPEND_ONLY = TRUE;