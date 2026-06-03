CREATE DATABASE uber_db;
USE uber_db;


-- Check NULL values in rides table
SELECT 
    SUM(CASE WHEN ride_id IS NULL THEN 1 ELSE 0 END) AS null_ride_id,
    SUM(CASE WHEN fare IS NULL THEN 1 ELSE 0 END) AS null_fare,
    SUM(CASE WHEN driver_id IS NULL THEN 1 ELSE 0 END) AS null_driver_id,
    SUM(CASE WHEN ride_status IS NULL THEN 1 ELSE 0 END) AS null_ride_status
FROM rides;


-- Check NULL values in city table
SELECT 
    SUM(CASE WHEN population IS NULL THEN 1 ELSE 0 END) AS null_population,
    SUM(CASE WHEN city_name IS NULL THEN 1 ELSE 0 END) AS null_city_name
FROM city;


-- Fix NULL population with average value
UPDATE city
SET population = (
    SELECT AVG(population) 
    FROM city 
    WHERE population IS NOT NULL
)
WHERE population IS NULL;


-- Fix NULL fare with average value
UPDATE rides
SET fare = (
    SELECT AVG(fare) 
    FROM rides 
    WHERE fare IS NOT NULL
)
WHERE fare IS NULL;


-- Delete rides with no ride_id
DELETE FROM rides
WHERE ride_id IS NULL;


-- Check for duplicate ride records
SELECT ride_id, COUNT(*) AS duplicate_count  
FROM rides
GROUP BY ride_id
HAVING COUNT(*) > 1;


-- Check for invalid fare values
SELECT ride_id, fare
FROM rides
WHERE fare <= 0;


-- Check ride_status for typos or invalid values
SELECT DISTINCT ride_status, COUNT(*) AS count
FROM rides
GROUP BY ride_status;