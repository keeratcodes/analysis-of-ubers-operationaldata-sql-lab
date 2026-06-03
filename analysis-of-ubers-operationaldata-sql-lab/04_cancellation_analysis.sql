USE uber_db;

-- Overall cancellation rate
SELECT 
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) AS canceled,
    SUM(CASE WHEN ride_status = 'Completed' THEN 1 ELSE 0 END) AS completed,
    ROUND(
        SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS cancellation_rate_pct
FROM rides;

-- Cancellation rate by payment method
SELECT 
    payment_method,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) AS canceled,
    ROUND(
        SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS cancellation_rate_pct
FROM rides
GROUP BY payment_method
ORDER BY cancellation_rate_pct DESC;

-- Cancellation rate by dynamic pricing
SELECT 
    dynamic_pricing,
    COUNT(*) AS total_rides,
    SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) AS canceled,
    ROUND(
        SUM(CASE WHEN ride_status = 'Canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS cancellation_rate_pct,
    ROUND(AVG(fare), 2) AS avg_fare
FROM rides
GROUP BY dynamic_pricing;

-- Revenue lost to cancellations
SELECT 
    ROUND(SUM(CASE WHEN ride_status = 'Completed' THEN fare ELSE 0 END), 2) AS revenue_earned,
    ROUND(SUM(CASE WHEN ride_status = 'Canceled' THEN fare ELSE 0 END), 2) AS revenue_lost,
    ROUND(
        SUM(CASE WHEN ride_status = 'Canceled' THEN fare ELSE 0 END) * 100.0 / SUM(fare), 2
    ) AS revenue_loss_pct
FROM rides;