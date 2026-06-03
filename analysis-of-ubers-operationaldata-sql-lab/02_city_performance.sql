USE uber_db;

-- Check rides per driver per city
SELECT TOP 3
    c.city_name,
    c.number_of_rides AS total_demand,
    c.number_of_drivers AS current_drivers,
    ROUND(c.number_of_rides * 1.0 / NULLIF(c.number_of_drivers, 0), 2) AS rides_per_driver,
    ROUND(c.avg_fare, 2) AS avg_fare
FROM city c
ORDER BY rides_per_driver DESC;


-- Overall driver quality metrics
SELECT 
    ROUND(AVG(avg_driver_rating), 2) AS overall_avg_rating,
    ROUND(MIN(avg_driver_rating), 2) AS lowest_rating,
    ROUND(MAX(avg_driver_rating), 2) AS highest_rating,
    SUM(CASE WHEN avg_driver_rating < 3 THEN 1 ELSE 0 END) AS poor_drivers,
    SUM(CASE WHEN avg_driver_rating >= 4.5 THEN 1 ELSE 0 END) AS top_drivers
FROM driver;


-- Fix invalid driver ratings above 5
UPDATE driver
SET avg_driver_rating = 5
WHERE avg_driver_rating > 5;


-- Top 3 cities needing driver recruitment combined score
SELECT TOP 3
    c.city_name,
    c.number_of_rides AS total_demand,
    c.number_of_drivers AS current_drivers,
    ROUND(c.number_of_rides * 1.0 / NULLIF(c.number_of_drivers, 0), 2) AS rides_per_driver,
    ROUND(c.avg_fare, 2) AS avg_fare,
    CASE 
        WHEN c.number_of_rides * 1.0 / NULLIF(c.number_of_drivers, 0) > 500 
            THEN 'Critical'
        WHEN c.number_of_rides * 1.0 / NULLIF(c.number_of_drivers, 0) > 200 
            THEN 'High'
        ELSE 'Medium'
    END AS recruitment_urgency
FROM city c
ORDER BY rides_per_driver DESC;