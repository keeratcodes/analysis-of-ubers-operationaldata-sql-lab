USE uber_db;

-- View 1: Average fare by city
CREATE VIEW vw_avg_fare_by_city AS
SELECT 
    start_city AS city,
    COUNT(*) AS total_completed_rides,
    ROUND(AVG(fare), 2) AS avg_fare,
    ROUND(MIN(fare), 2) AS min_fare,
    ROUND(MAX(fare), 2) AS max_fare,
    ROUND(SUM(fare), 2) AS total_revenue
FROM rides
WHERE ride_status = 'Completed'
GROUP BY start_city;

-- Test View 1
SELECT * FROM vw_avg_fare_by_city ORDER BY avg_fare DESC;

-- View 2: Driver performance metrics
CREATE VIEW vw_driver_performance AS
SELECT 
    driver_id,
    driver_name,
    vehicle_type,
    avg_driver_rating,
    total_rides,
    ROUND(total_earnings, 2) AS total_earnings,
    ride_acceptance_rate,
    years_of_experience,
    driver_status,
    CASE 
        WHEN avg_driver_rating >= 4.5 THEN 'Top Performer'
        WHEN avg_driver_rating >= 3.5 THEN 'Average Performer'
        ELSE 'Needs Improvement'
    END AS performance_category
FROM driver;

-- Test View 2
SELECT performance_category, COUNT(*) AS total_drivers
FROM vw_driver_performance
GROUP BY performance_category
ORDER BY total_drivers DESC;

-- View 3: Revenue summary
CREATE VIEW vw_revenue_summary AS
SELECT 
    transaction_status,
    COUNT(*) AS total_transactions,
    ROUND(SUM(fare), 2) AS total_fare,
    ROUND(AVG(fare), 2) AS avg_fare,
    ROUND(SUM(driver_earnings), 2) AS total_driver_earnings,
    ROUND(SUM(uber_commission), 2) AS total_uber_commission
FROM payment
GROUP BY transaction_status;

-- Test View 3
SELECT * FROM vw_revenue_summary;