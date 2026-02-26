WITH daily AS (
    SELECT *
    FROM {{ ref('prep_weather_daily') }}
),
weekly_agg AS (
    SELECT
        airport_code,
        DATE_TRUNC('week', date) AS week_start,
        AVG(avg_temp_c) AS avg_temp_c,
        MIN(min_temp_c) AS min_temp_c,
        MAX(max_temp_c) AS max_temp_c,
        SUM(precipitation_mm) AS total_precipitation_mm,
        SUM(max_snow_mm) AS total_snow_mm,
        AVG(avg_wind_direction) AS avg_wind_direction,
        AVG(avg_wind_speed_kmh) AS avg_wind_speed_kmh,
        MAX(wind_peakgust_kmh) AS max_wind_peakgust_kmh
    FROM daily
    GROUP BY airport_code, DATE_TRUNC('week', date)
)
SELECT *
FROM weekly_agg
ORDER BY airport_code, week_start;