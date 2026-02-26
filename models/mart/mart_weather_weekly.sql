SELECT
    DATE_TRUNC('week', date) AS week_start,
    AVG(min_temp_c) AS avg_min_temp_c,
    AVG(max_temp_c) AS avg_max_temp_c,
    SUM(precipitation_mm) AS total_precipitation_mm,
    SUM(max_snow_mm) AS total_snow_mm,
    AVG(avg_wind_speed_kmh) AS avg_wind_speed_kmh
FROM {{ ref('prep_weather_daily') }}
GROUP BY DATE_TRUNC('week', date)
ORDER BY week_start