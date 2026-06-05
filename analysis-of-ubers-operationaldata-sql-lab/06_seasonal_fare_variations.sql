USE uber_db;

-- Average fare by season
SELECT 
    CASE 
        WHEN DATEPART(MONTH, ride_date) IN (12, 1, 2) THEN 'Winter'
        WHEN DATEPART(MONTH, ride_date) IN (3, 4, 5)  THEN 'Spring'
        WHEN DATEPART(MONTH, ride_date) IN (6, 7, 8)  THEN 'Summer'
        ELSE 'Autumn'
    END AS season,
    COUNT(*) AS total_rides,
    ROUND(AVG(fare), 2) AS avg_fare,
    ROUND(MIN(fare), 2) AS min_fare,
    ROUND(MAX(fare), 2) AS max_fare,
    ROUND(SUM(fare), 2) AS total_revenue
FROM rides
WHERE ride_status = 'Completed'
GROUP BY 
    CASE 
        WHEN DATEPART(MONTH, ride_date) IN (12, 1, 2) THEN 'Winter'
        WHEN DATEPART(MONTH, ride_date) IN (3, 4, 5)  THEN 'Spring'
        WHEN DATEPART(MONTH, ride_date) IN (6, 7, 8)  THEN 'Summer'
        ELSE 'Autumn'
    END
ORDER BY avg_fare DESC;

-- Monthly fare trend
SELECT 
    YEAR(ride_date) AS year,
    MONTH(ride_date) AS month,
    DATENAME(MONTH, ride_date) AS month_name,
    COUNT(*) AS total_rides,
    ROUND(AVG(fare), 2) AS avg_fare,
    ROUND(SUM(fare), 2) AS total_revenue
FROM rides
WHERE ride_status = 'Completed'
GROUP BY YEAR(ride_date), MONTH(ride_date), DATENAME(MONTH, ride_date)
ORDER BY year, month;

-- Fare anomalies above 3x average
SELECT 
    ride_id,
    ride_date,
    fare,
    dynamic_pricing,
    ride_status,
    ROUND((SELECT AVG(fare) FROM rides), 2) AS overall_avg_fare,
    ROUND(fare / (SELECT AVG(fare) FROM rides), 2) AS times_above_avg
FROM rides
WHERE fare > (SELECT AVG(fare) FROM rides) * 3
ORDER BY fare DESC;

-- Dynamic pricing impact by season
SELECT 
    CASE 
        WHEN DATEPART(MONTH, ride_date) IN (12, 1, 2) THEN 'Winter'
        WHEN DATEPART(MONTH, ride_date) IN (3, 4, 5)  THEN 'Spring'
        WHEN DATEPART(MONTH, ride_date) IN (6, 7, 8)  THEN 'Summer'
        ELSE 'Autumn'
    END AS season,
    dynamic_pricing,
    COUNT(*) AS total_rides,
    ROUND(AVG(fare), 2) AS avg_fare
FROM rides
GROUP BY 
    CASE 
        WHEN DATEPART(MONTH, ride_date) IN (12, 1, 2) THEN 'Winter'
        WHEN DATEPART(MONTH, ride_date) IN (3, 4, 5)  THEN 'Spring'
        WHEN DATEPART(MONTH, ride_date) IN (6, 7, 8)  THEN 'Summer'
        ELSE 'Autumn'
    END,
    dynamic_pricing
ORDER BY season, avg_fare DESC;