WITH airport_stats AS (
    SELECT
        f.origin AS airport,
        COUNT(*) AS total_departures,
        COUNT(DISTINCT f.tail_number) AS unique_planes,
        COUNT(DISTINCT f.airline) AS unique_airlines,
        SUM(CASE WHEN f.cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_departures,
        SUM(CASE WHEN f.diverted = 1 THEN 1 ELSE 0 END) AS diverted_departures
    FROM s_munzeralawad.prep_flights f
    GROUP BY f.origin
)
SELECT
    a.faa,
    a.name,
    a.city,
    a.country,
    s.total_departures,
    s.unique_planes,
    s.unique_airlines,
    s.cancelled_departures,
    s.diverted_departures,
    w.min_temp_c AS daily_min_temp,
    w.max_temp_c AS daily_max_temp,
    w.precipitation_mm AS daily_precipitation,
    w.max_snow_mm AS daily_snowfall,
    w.avg_wind_speed_kmh AS daily_avg_wind_speed,
    w.avg_wind_direction AS daily_avg_wind_dir,
    w.wind_peakgust_kmh AS daily_peak_wind
FROM airport_stats s
LEFT JOIN s_munzeralawad.prep_airports a ON s.airport = a.faa
LEFT JOIN s_munzeralawad.prep_weather_daily w ON s.airport = w.station_id::text