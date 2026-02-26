SELECT
    f.origin AS origin_airport,
    f.dest AS dest_airport,
    COUNT(*) AS total_flights,
    COUNT(DISTINCT f.tail_number) AS unique_planes,
    COUNT(DISTINCT f.airline) AS unique_airlines,
    AVG(f.actual_elapsed_time) AS avg_elapsed_time,
    AVG(f.arrival_delay) AS avg_arrival_delay,
    MAX(f.arrival_delay) AS max_delay,
    MIN(f.arrival_delay) AS min_delay,
    SUM(CASE WHEN f.cancelled = 1 THEN 1 ELSE 0 END) AS total_cancelled,
    SUM(CASE WHEN f.diverted = 1 THEN 1 ELSE 0 END) AS total_diverted
FROM {{ ref('prep_flights') }} f
GROUP BY f.origin, f.dest