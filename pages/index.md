---
title: NYC Taxi Data
sidebar: never
---

```sql date_range
select * from dates
```

This is an exploration of NYC taxi data. It includes a summary of the data, rides by day, and rides by pickup location.

<DateRange 
  name=date_range 
  data={date_range} 
  dates=day
  presetRanges={['Last 7 Days', 'Last 30 Days']}
/>


```sql aggregate_stats
select
  sum(rides) as rides,
  sum(fare_amount) as fare_amount,
  sum(trip_distance) as trip_distance,
  sum(fare_amount)/sum(trip_distance) as fare_per_mile
from summary
where day between '${inputs.date_range.start}' and '${inputs.date_range.end}'
```

<BigValue
  data={aggregate_stats}
  value=rides
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
from daily
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
  PULocationID,
  zone,
  borough,
  sum(rides) as rides,
  sum(fare_amount) as fare_amount,
  sum(trip_distance) as trip_distance
from location
left join zones.zones z on location.PULocationID = z.location_id
where day between '${inputs.date_range.start}' and '${inputs.date_range.end}'
group by all
order by 1
```

<AreaMap
  data={fares_by_pickup_location}
  geoJsonUrl='/taxi_zones.geojson'
  geoId=objectid
  areaCol=PULocationID
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


