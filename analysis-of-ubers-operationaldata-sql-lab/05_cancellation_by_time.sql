USE uber_db;

-- Cancellation rate by hour of day
SELECT 
    DATEPART(HOUR, start_time) AS hour_of_day,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) AS canceled,
    ROUND(
        SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS cancellation_rate_pct
FROM rides
GROUP BY DATEPART(HOUR, start_time)
ORDER BY cancellation_rate_pct DESC;

-- Cancellation by time bucket
SELECT 
    CASE 
        WHEN DATEPART(HOUR, start_time) BETWEEN 6 AND 11 THEN 'Morning (6am-12pm)'
        WHEN DATEPART(HOUR, start_time) BETWEEN 12 AND 17 THEN 'Afternoon (12pm-6pm)'
        WHEN DATEPART(HOUR, start_time) BETWEEN 18 AND 21 THEN 'Evening (6pm-10pm)'
        ELSE 'Night (10pm-6am)'
    END AS time_of_day,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) AS canceled,
    ROUND(
        SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS cancellation_rate_pct,
    ROUND(SUM(CASE WHEN ride_status = 'Canceled' THEN fare ELSE 0 END), 2) AS revenue_lost
FROM rides
GROUP BY 
    CASE 
        WHEN DATEPART(HOUR, start_time) BETWEEN 6 AND 11 THEN 'Morning (6am-12pm)'
        WHEN DATEPART(HOUR, start_time) BETWEEN 12 AND 17 THEN 'Afternoon (12pm-6pm)'
        WHEN DATEPART(HOUR, start_time) BETWEEN 18 AND 21 THEN 'Evening (6pm-10pm)'
        ELSE 'Night (10pm-6am)'
    END
ORDER BY cancellation_rate_pct DESC;

-- Top 5 hours by revenue lost
SELECT TOP 5
    DATEPART(HOUR, start_time) AS hour_of_day,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) AS canceled,
    ROUND(
        SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS cancellation_rate_pct,
    ROUND(SUM(CASE WHEN ride_status = 'Canceled' THEN fare ELSE 0 END), 2) AS revenue_lost
FROM rides
GROUP BY DATEPART(HOUR, start_time)
ORDER BY revenue_lost DESC;