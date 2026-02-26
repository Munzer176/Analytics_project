WITH airport_stats AS (
    SELECT
        f.origin AS airport,
        COUNT(*) AS total_departures,
        COUNT(DISTINCT f.tail_number) AS unique_planes,
        COUNT(DISTINCT f.airline) AS unique_airlines,
        SUM(CASE WHEN f.cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_departures,
        SUM(CASE WHEN f.diverted = 1 THEN 1 ELSE 0 END) AS diverted_departures
    FROM {{ ref('prep_flights') }} f
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
    w.daily_min_temp,
    w.daily_max_temp,
    w.daily_precipitation,
    w.daily_snowfall,
    w.daily_avg_wind_speed,
    w.daily_avg_wind_dir,
    w.daily_peak_wind
FROM airport_stats s
LEFT JOIN {{ ref('prep_airports') }} a ON s.airport = a.faa
LEFT JOIN {{ ref('prep_weather_daily') }} w ON a.faa = w.faa