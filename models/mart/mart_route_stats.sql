WITH route_stats AS (
    SELECT
        origin,
        dest,
        COUNT(*) AS total_flights,
        COUNT(DISTINCT tail_number) AS unique_planes,
        COUNT(DISTINCT airline) AS unique_airlines,
        AVG(actual_elapsed_time) AS avg_elapsed_time,
        AVG(arr_delay) AS avg_arrival_delay,
        MAX(arr_delay) AS max_arrival_delay,
        MIN(arr_delay) AS min_arrival_delay,
        SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS total_cancelled,
        SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS total_diverted
    FROM {{ ref('prep_flights') }}
    GROUP BY origin, dest
),
origin_info AS (
    SELECT faa, name AS origin_name, city AS origin_city, country AS origin_country
    FROM {{ ref('prep_airports') }}
),
dest_info AS (
    SELECT faa, name AS dest_name, city AS dest_city, country AS dest_country
    FROM {{ ref('prep_airports') }}
)
SELECT
    r.origin,
    o.origin_name,
    o.origin_city,
    o.origin_country,
    r.dest,
    d.dest_name,
    d.dest_city,
    d.dest_country,
    r.total_flights,
    r.unique_planes,
    r.unique_airlines,
    r.avg_elapsed_time,
    r.avg_arrival_delay,
    r.max_arrival_delay,
    r.min_arrival_delay,
    r.total_cancelled,
    r.total_diverted
FROM route_stats r
LEFT JOIN origin_info o ON r.origin = o.faa
LEFT JOIN dest_info d ON r.dest = d.faa