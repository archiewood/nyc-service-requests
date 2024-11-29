---
title: NYC Taxi Data 2022
sidebar: never
---

```sql date_range
select * from taxi.dates
```

This is an exploration of NYC taxi data in 2022. It includes a summary of the data, rides by day, and rides by pickup location.

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
from taxi.summary
where day between '${inputs.date_range.start}' and '${inputs.date_range.end}'
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

```sql fares_by_day
select *
from taxi.daily
where day between '${inputs.date_range.start}' and '${inputs.date_range.end}'
group by all
order by day
```

<Grid>

<LineChart
  title="Rides by Day"
  data={fares_by_day}
  x=day
  y=rides
/>

<LineChart
  title="Fare Amount by Day"
  data={fares_by_day}
  x=day
  y=fare_amount
  yFmt=usd1m
/>

<LineChart
  title="Trip Distance by Day"
  data={fares_by_day}
  x=day
  y=trip_distance
/>

<LineChart
  title="Fare per Mile by Day"
  data={fares_by_day}
  x=day
  y=fare_per_mile
/>
</Grid>



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
group by all
order by rides desc
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


```sql fares_by_pickup_borough
select
  borough,
  '/borough/' || borough as borough_link,
  sum(rides) as rides,
  sum(fare_amount) as fare_amount,
  sum(trip_distance) as trip_distance
from taxi.location l
left join zones.zones z on l.pickup_location_id = z.location_id
where day between '${inputs.date_range.start}' and '${inputs.date_range.end}'
and borough is not null
group by all
order by rides desc
```

<DataTable data={fares_by_pickup_borough} link=borough_link>
  <Column id=borough/>
  <Column id=rides fmt=num0/>
  <Column id=fare_amount fmt=usd1m/>
  <Column id=trip_distance fmt=num0/>
</DataTable>