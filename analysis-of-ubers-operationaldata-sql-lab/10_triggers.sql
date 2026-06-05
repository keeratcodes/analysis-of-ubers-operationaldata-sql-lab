USE uber_db;

-- Create audit log table
CREATE TABLE ride_status_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    ride_id VARCHAR(100),
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at DATETIME DEFAULT GETDATE(),
    changed_by VARCHAR(100) DEFAULT SYSTEM_USER
);

-- Trigger 1: Log every ride status change
CREATE TRIGGER trg_ride_status_change
ON rides
AFTER UPDATE
AS
BEGIN
    IF UPDATE(ride_status)
    BEGIN
        INSERT INTO ride_status_log (ride_id, old_status, new_status)
        SELECT 
            d.ride_id,
            d.ride_status AS old_status,
            i.ride_status AS new_status
        FROM deleted d
        JOIN inserted i ON d.ride_id = i.ride_id
        WHERE d.ride_status <> i.ride_status;
    END
END;

-- Test Trigger 1
UPDATE rides
SET ride_status = 'Completed'
WHERE ride_id = (SELECT TOP 1 ride_id FROM rides WHERE ride_status = 'Canceled');

-- Verify audit log
SELECT * FROM ride_status_log;

-- Trigger 2: Prevent negative fare values
CREATE TRIGGER trg_prevent_negative_fare
ON rides
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE fare < 0)
    BEGIN
        RAISERROR('Fare cannot be negative.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

-- Test Trigger 2: Should throw error
UPDATE rides
SET fare = -50
WHERE ride_id = (SELECT TOP 1 ride_id FROM rides);