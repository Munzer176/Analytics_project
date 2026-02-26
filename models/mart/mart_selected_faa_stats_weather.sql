WITH daily_airport_stats AS (
    SELECT
        origin AS airport_code,
        COUNT(*) AS total_departures,
        COUNT(DISTINCT tail_number) AS unique_planes,
        COUNT(DISTINCT airline) AS unique_airlines,
        SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS total_cancelled,
        SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS total_diverted,
        SUM(CASE WHEN cancelled = 0 AND diverted = 0 THEN 1 ELSE 0 END) AS total_occurred
    FROM {{ ref('prep_flights') }}
    GROUP BY origin
),
weather_daily AS (
    SELECT *
    FROM {{ ref('prep_weather_daily') }}
)
SELECT
    a.airport_code,
    w.date,
    a.total_departures,
    a.unique_planes,
    a.unique_airlines,
    a.total_cancelled,
    a.total_diverted,
    a.total_occurred,
    w.avg_temp_c,
    w.min_temp_c,
    w.max_temp_c,
    w.precipitation_mm,
    w.max_snow_mm,
    w.avg_wind_direction,
    w.avg_wind_speed_kmh,
    w.wind_peakgust_kmh
FROM daily_airport_stats a
LEFT JOIN weather_daily w
    ON a.airport_code = w.airport_code