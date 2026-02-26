WITH departures AS (
    SELECT
        origin,
        COUNT(*) AS total_departures,
        COUNT(DISTINCT tail_number) AS unique_planes,
        COUNT(DISTINCT airline) AS unique_airlines,
        SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_departures,
        SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS diverted_departures
    FROM {{ ref('prep_flights') }}
    GROUP BY origin
),
arrivals AS (
    SELECT
        dest,
        COUNT(*) AS total_arrivals,
        SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END) AS cancelled_arrivals,
        SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END) AS diverted_arrivals
    FROM {{ ref('prep_flights') }}
    GROUP BY dest
)
SELECT
    a.faa,
    a.name,
    a.city,
    a.country,
    d.total_departures,
    d.unique_planes,
    d.unique_airlines,
    d.cancelled_departures,
    d.diverted_departures,
    ar.total_arrivals,
    ar.cancelled_arrivals,
    ar.diverted_arrivals
FROM {{ ref('prep_airports') }} a
LEFT JOIN departures d ON a.faa = d.origin
LEFT JOIN arrivals ar ON a.faa = ar.dest