USE uber_db;

SELECT 'city' AS table_name, COUNT(*) AS total_rows FROM city
UNION ALL
SELECT 'driver', COUNT(*) FROM driver
UNION ALL
SELECT 'rides', COUNT(*) FROM rides
UNION ALL
SELECT 'payment', COUNT(*) FROM payment;