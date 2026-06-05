# Analysis of Uber's Operational Data

> ✅ Status: Completed

End-to-end SQL analysis of Uber's operational data uncovering 
revenue leakage, cancellation patterns, and driver performance issues.

## Key Findings
- 52.21% cancellation rate — more rides canceled than completed
- 35.23% revenue leakage — $16,777 lost to failed payments
- 60% of drivers rated below 3.5 — needs improvement
- 5pm is the worst hour — 68% cancellation rate, $1,888 lost
- Dynamic pricing NOT generating higher fares in 3 out of 4 seasons
- North Michaelberg — Critical, 1,356 rides per driver

## Files

| File | Description |
|---|---|
| 01_data_cleaning.sql | NULL handling, duplicate removal, data validation |
| 02_city_performance.sql | Top 3 cities needing driver recruitment |
| 03_revenue_leakage.sql | Failed payments and revenue loss analysis |
| 04_cancellation_analysis.sql | 52.21% cancellation rate investigation |
| 05_cancellation_by_time.sql | Peak cancellation hours and revenue impact |
| 06_seasonal_fare_variations.sql | Seasonal fare trends and anomalies |
| 07_avg_ride_duration.sql | Ride duration vs customer satisfaction |
| 08_views.sql | 3 reusable views for reporting |
| 09_indexes.sql | 5 indexes for query optimization |
| 10_triggers.sql | Audit trail and data integrity triggers |

## Concepts Used
- Data Cleaning — NULL imputation, deduplication, validation
- Aggregations — SUM(), AVG(), COUNT(), GROUP BY
- Date functions — DATEPART(), DATEDIFF(), DATENAME()
- CASE statements for bucketing and categorization
- Views for reusable reporting
- Indexes for query performance optimization
- Triggers for audit logging and data integrity

## Tools
SQL Server · Azure SQL Edge · Docker · VS Code
