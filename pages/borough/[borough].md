# {params.borough}

```sql date_range
select * from taxi.dates
```

<DateRange 
  name=date_range 
  data={date_range} 
  dates=day
/>

```sql aggregate_stats
select
  sum(rides) as rides,
  sum(fare_amount) as fare_amount,
  sum(trip_distance) as trip_distance,
  sum(fare_amount)/sum(trip_distance) as fare_per_mile
from taxi.summary_borough
left join zones.zones z on taxi.summary_borough.pickup_location_id = z.location_id
where day between '${inputs.date_range.start}' and '${inputs.date_range.end}'
and lower(borough) = lower('${params.borough}')
```

<BigValue
  data={aggregate_stats}
  value=rides
  fmt=num0
/>

<BigValue
  data={aggregate_stats}
  value=fare_amount
  fmt=usd1m
/>

<BigValue
  data={aggregate_stats}
  value=trip_distance
  fmt='#,##0 "mi"'
/>

<BigValue
  data={aggregate_stats}
  value=fare_per_mile
  fmt=usd2
/>



```sql fares_by_pickup_location
select
  pickup_location_id,
  zone,
  borough,
  sum(rides) as rides,
  sum(fare_amount) as fare_amount,
  sum(trip_distance) as trip_distance
from taxi.location l
left join zones.zones z on l.pickup_location_id = z.location_id
where day between '${inputs.date_range.start}' and '${inputs.date_range.end}'
and lower(borough) = lower('${params.borough}')
group by all
order by 1
```

<AreaMap
  data={fares_by_pickup_location}
  geoJsonUrl='/taxi_zones.geojson'
  geoId=objectid
  areaCol=pickup_location_id
  value=rides
  valueFmt=num0
  title="Rides by Pickup Location"
  labelCol=zone
  tooltip={[
    {id: 'zone', showColumnName: false, valueClass: 'text-xl font-semibold'},
    {id: 'borough', showColumnName: false, valueClass: 'text-sm text-gray-500'},
    {id: 'rides', fmt: 'num0', fieldClass: 'text-[grey]', valueClass: 'text-[green]'},
    {id: 'fare_amount', fmt: 'usd', fieldClass: 'text-[grey]', valueClass: 'text-[green]'},
    {id: 'trip_distance', fmt: 'num0', fieldClass: 'text-[grey]', valueClass: 'text-[green]'},
]}
/>