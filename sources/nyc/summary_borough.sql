select
  date_trunc('day', tpep_dropoff_datetime) as day,
  PULocationID,
  count(*) as rides,
  sum(fare_amount) as fare_amount,
  sum(trip_distance) as trip_distance,
  sum(fare_amount)/sum(trip_distance) as fare_per_mile
from nyc.taxi
where tpep_dropoff_datetime > '2022-01-01'
group by all