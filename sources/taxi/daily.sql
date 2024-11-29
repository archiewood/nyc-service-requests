select
  date_trunc(dropoff_datetime, DAY) as day,
  count(*) as rides,
  sum(fare_amount) as fare_amount,
  sum(trip_distance) as trip_distance,
  sum(fare_amount)/sum(trip_distance) as fare_per_mile
from bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2022
where pickup_datetime between '2022-01-01' and '2022-12-31'
group by all
order by day