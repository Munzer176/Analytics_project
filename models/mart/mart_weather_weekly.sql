SELECT
    date_trunc('week', w.date) AS week_start,
    AVG(w.daily_min_temp) AS avg_min_temp,
    AVG(w.daily_max_temp) AS avg_max_temp,
    SUM(w.daily_precipitation) AS total_precipitation,
    SUM(w.daily_snowfall) AS total_snowfall,
    AVG(w.daily_avg_wind_speed) AS avg_wind_speed
FROM {{ ref('prep_weather_daily') }} w
GROUP BY 1
ORDER BY 1