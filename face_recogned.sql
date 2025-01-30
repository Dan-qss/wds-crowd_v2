-- Create table for face detection results
CREATE TABLE IF NOT EXISTS face_detection_results (
    id BIGSERIAL PRIMARY KEY,
    camera_id INTEGER NOT NULL,
    person_name VARCHAR(100) NOT NULL,
    position JSONB,  -- Store position data as JSON to handle different coordinate formats
    status VARCHAR(50),
    detected_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    
    -- Add indexes for common queries
    CONSTRAINT face_detection_results_camera_id_check CHECK (camera_id > 0)
);

-- Create indexes for faster querying
CREATE INDEX idx_face_detection_camera_id ON face_detection_results(camera_id);
CREATE INDEX idx_face_detection_person_name ON face_detection_results(person_name);
CREATE INDEX idx_face_detection_detected_at ON face_detection_results(detected_at);

-- Create a function to automatically partition by month (optional, for scalability)
CREATE OR REPLACE FUNCTION create_face_detection_partition()
RETURNS TRIGGER AS $$
DECLARE
    partition_date TEXT;
    partition_name TEXT;
BEGIN
    partition_date := TO_CHAR(NEW.detected_at, 'YYYY_MM');
    partition_name := 'face_detection_results_' || partition_date;
    
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = partition_name) THEN
        EXECUTE format(
            'CREATE TABLE IF NOT EXISTS %I PARTITION OF face_detection_results 
            FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            date_trunc('month', NEW.detected_at),
            date_trunc('month', NEW.detected_at + interval '1 month')
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create the trigger for automatic partitioning
CREATE TRIGGER create_face_detection_partition_trigger
    BEFORE INSERT ON face_detection_results
    FOR EACH ROW
    EXECUTE FUNCTION create_face_detection_partition();

-- Add comment to document the table
COMMENT ON TABLE face_detection_results IS 'Stores face detection results from camera system including person identification and positioning data';
