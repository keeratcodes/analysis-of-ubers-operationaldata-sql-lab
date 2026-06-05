USE uber_db;

-- Index 1: Ride date for faster date filtering
CREATE INDEX idx_rides_ride_date
ON rides(ride_date);

-- Index 2: Ride status for faster filtering
CREATE INDEX idx_rides_ride_status
ON rides(ride_status);

-- Index 3: Payment method for faster payment queries
CREATE INDEX idx_rides_payment_method
ON rides(payment_method);

-- Index 4: Driver ID for faster JOINs
CREATE INDEX idx_rides_driver_id
ON rides(driver_id);

-- Index 5: Payment transaction status
CREATE INDEX idx_payment_transaction_status
ON payment(transaction_status);

-- Verify all indexes
SELECT 
    t.name AS table_name,
    i.name AS index_name,
    i.type_desc
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.type > 0
ORDER BY t.name;