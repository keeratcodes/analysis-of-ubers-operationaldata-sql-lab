USE uber_db;

-- Overall ride duration analysis
SELECT 
    ROUND(AVG(DATEDIFF(MINUTE, start_time, end_time)), 2) AS avg_duration_minutes,
    ROUND(MIN(DATEDIFF(MINUTE, start_time, end_time)), 2) AS min_duration_minutes,
    ROUND(MAX(DATEDIFF(MINUTE, start_time, end_time)), 2) AS max_duration_minutes,
    ROUND(AVG(distance_km), 2) AS avg_distance_km,
    ROUND(AVG(fare), 2) AS avg_fare
FROM rides
WHERE ride_status = 'Completed'
AND DATEDIFF(MINUTE, start_time, end_time) > 0
AND DATEDIFF(MINUTE, start_time, end_time) < 300;

-- Ride duration vs customer rating
SELECT 
    CASE 
        WHEN DATEDIFF(MINUTE, start_time, end_time) < 30 
            THEN 'Short (under 30 min)'
        WHEN DATEDIFF(MINUTE, start_time, end_time) BETWEEN 30 AND 90 
            THEN 'Medium (30-90 min)'
        WHEN DATEDIFF(MINUTE, start_time, end_time) BETWEEN 91 AND 180 
            THEN 'Long (91-180 min)'
        ELSE 'Very Long (over 180 min)'
    END AS duration_bucket,
    COUNT(*) AS total_rides,
    ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating,
    ROUND(AVG(fare), 2) AS avg_fare
FROM rides
WHERE ride_status = 'Completed'
AND rating IS NOT NULL
AND DATEDIFF(MINUTE, start_time, end_time) > 0
AND DATEDIFF(MINUTE, start_time, end_time) < 300
GROUP BY 
    CASE 
        WHEN DATEDIFF(MINUTE, start_time, end_time) < 30 
            THEN 'Short (under 30 min)'
        WHEN DATEDIFF(MINUTE, start_time, end_time) BETWEEN 30 AND 90 
            THEN 'Medium (30-90 min)'
        WHEN DATEDIFF(MINUTE, start_time, end_time) BETWEEN 91 AND 180 
            THEN 'Long (91-180 min)'
        ELSE 'Very Long (over 180 min)'
    END
ORDER BY avg_rating DESC;