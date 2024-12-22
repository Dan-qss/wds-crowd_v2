# Crowd Management System - Database Documentation

## Overview
This document details the PostgreSQL database implementation for the Crowd Management System, featuring a partitioned table design for efficient data management of crowd measurements across multiple zones and cameras.

## Database Structure

### Main Table: crowd_measurements
```sql
CREATE TABLE crowd_measurements (
    measurement_id SERIAL,
    camera_id INTEGER NOT NULL,
    zone_name VARCHAR(100) NOT NULL,
    area_name VARCHAR(100) NOT NULL,
    capacity INTEGER NOT NULL,
    number_of_people INTEGER NOT NULL,
    crowding_level VARCHAR(50) NOT NULL,
    crowding_percentage DECIMAL(5,2) NOT NULL,
    measured_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (measurement_id, measured_at)
) PARTITION BY RANGE (measured_at);
```

### Table Partitioning
- Partitions are created monthly
- Naming convention: `crowd_data_MM_YYYY` (e.g., `crowd_data_12_2024`)
- Each partition contains one month of data
- Historical data is preserved indefinitely

### Indexes
```sql
CREATE INDEX idx_crowd_measurements_measured_at ON crowd_measurements(measured_at);
CREATE INDEX idx_crowd_measurements_camera_zone ON crowd_measurements(camera_id, zone_name);
```

## Management Functions

### 1. Monthly Partition Creation
```sql
CREATE OR REPLACE FUNCTION create_monthly_partition()
RETURNS void AS $$
DECLARE
    current_month DATE := DATE_TRUNC('month', CURRENT_DATE);
    next_month DATE := current_month + INTERVAL '1 month';
    partition_name TEXT;
    start_date TIMESTAMP;
    end_date TIMESTAMP;
BEGIN
    partition_name := 'crowd_data_' || TO_CHAR(current_month, 'MM_YYYY');
    start_date := current_month::TIMESTAMP;
    end_date := next_month::TIMESTAMP;
    
    IF NOT EXISTS (
        SELECT 1
        FROM pg_class c
        WHERE c.relname = partition_name
    ) THEN
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF crowd_measurements ' ||
            'FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            start_date,
            end_date
        );
        RAISE NOTICE 'Created partition %', partition_name;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

### 2. Historical Partition Creation
```sql
CREATE OR REPLACE FUNCTION create_past_partitions(months_back integer)
RETURNS void AS $$
DECLARE
    current_date DATE;
    partition_name TEXT;
    start_date TIMESTAMP;
    end_date TIMESTAMP;
BEGIN
    FOR i IN 0..months_back LOOP
        current_date := DATE_TRUNC('month', CURRENT_DATE - (i * INTERVAL '1 month'));
        partition_name := 'crowd_data_' || TO_CHAR(current_date, 'MM_YYYY');
        start_date := current_date::TIMESTAMP;
        end_date := (current_date + INTERVAL '1 month')::TIMESTAMP;
        
        IF NOT EXISTS (
            SELECT 1
            FROM pg_class c
            WHERE c.relname = partition_name
        ) THEN
            EXECUTE format(
                'CREATE TABLE %I PARTITION OF crowd_measurements ' ||
                'FOR VALUES FROM (%L) TO (%L)',
                partition_name,
                start_date,
                end_date
            );
            RAISE NOTICE 'Created partition %', partition_name;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

## Usage Guide

### Initial Setup
1. Create the main table
2. Create management functions
3. Create indexes
4. Initialize partitions:
```sql
-- Create partitions for the last 24 months
SELECT create_past_partitions(24);
-- Create partition for current month
SELECT create_monthly_partition();
```

### Data Insertion
```sql
-- Current data
INSERT INTO crowd_measurements 
(camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage)
VALUES 
(1, 'Zone A', 'Area 1', 100, 50, 'Medium', 50.0);

-- Historical data
INSERT INTO crowd_measurements 
(camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at)
VALUES 
(1, 'Zone A', 'Area 1', 100, 50, 'Medium', 50.0, '2023-12-10 12:00:00');
```

### Query Examples

#### Query Current Month
```sql
SELECT * FROM crowd_data_12_2024;
```

#### Query Multiple Months
```sql
SELECT * FROM (
    SELECT * FROM crowd_data_11_2024
    UNION ALL
    SELECT * FROM crowd_data_12_2024
) as combined_data;
```

#### Query by Date Range
```sql
SELECT * FROM crowd_measurements
WHERE measured_at BETWEEN '2024-01-01' AND '2024-12-31';
```

#### Aggregated Analysis
```sql
SELECT 
    zone_name,
    area_name,
    DATE_TRUNC('hour', measured_at) as hour,
    AVG(number_of_people) as avg_people,
    MAX(crowding_percentage) as max_crowding
FROM crowd_measurements
WHERE measured_at >= CURRENT_DATE - INTERVAL '7 days'
GROUP BY zone_name, area_name, DATE_TRUNC('hour', measured_at)
ORDER BY hour DESC;
```

## Maintenance Notes

### Monthly Tasks
- Monitor partition creation for new months
- Verify data insertion in correct partitions
- Check index performance

### Performance Considerations
- Queries spanning multiple partitions may be slower
- Use specific date ranges when possible
- Consider creating additional indexes based on query patterns

## Troubleshooting

### Common Issues
1. Data not appearing in queries
   - Verify correct partition exists
   - Check date ranges in query
   - Verify data insertion timestamp

2. Slow queries
   - Check if using appropriate indexes
   - Verify query date ranges
   - Consider partition pruning

### Verification Queries
```sql
-- List all partitions
SELECT inhrelid::regclass AS partition_name 
FROM pg_inherits 
WHERE inhparent = 'crowd_measurements'::regclass;

-- Check partition sizes
SELECT pg_size_pretty(pg_total_relation_size(tablename::text)) as size,
       tablename 
FROM pg_tables 
WHERE tablename LIKE 'crowd_data_%';
```
