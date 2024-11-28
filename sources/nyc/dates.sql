select 
  date_trunc('day', tpep_dropoff_datetime) as day
from nyc.taxi
where tpep_dropoff_datetime > '2022-01-01'
group by all