USE uber_db;


-- Check transaction status breakdown
SELECT 
    transaction_status,
    COUNT(*) AS total_transactions,
    ROUND(SUM(fare), 2) AS total_fare,
    ROUND(AVG(fare), 2) AS avg_fare
FROM payment
GROUP BY transaction_status
ORDER BY total_transactions DESC;


-- Total revenue leakage summary
SELECT 
    ROUND(SUM(CASE WHEN transaction_status = 'Failed' THEN fare ELSE 0 END), 2) AS lost_revenue,
    ROUND(SUM(CASE WHEN transaction_status = 'Pending' THEN fare ELSE 0 END), 2) AS at_risk_revenue,
    ROUND(SUM(CASE WHEN transaction_status = 'Completed' THEN fare ELSE 0 END), 2) AS collected_revenue,
    ROUND(SUM(fare), 2) AS total_revenue,
    ROUND(
        SUM(CASE WHEN transaction_status = 'Failed' THEN fare ELSE 0 END) * 100.0 / SUM(fare), 2
    ) AS leakage_pct
FROM payment;


-- Revenue leakage by payment method
SELECT 
    payment_method,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END) AS failed_count,
    ROUND(SUM(CASE WHEN transaction_status = 'Failed' THEN fare ELSE 0 END), 2) AS failed_revenue,
    ROUND(
        SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS failure_rate_pct
FROM payment
GROUP BY payment_method
ORDER BY failure_rate_pct DESC;