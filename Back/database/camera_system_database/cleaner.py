import psycopg2
from typing import Dict
from db_config import DB_CONFIG

class SpecificRecordCleaner:
    def __init__(self, db_config: Dict[str, str]):
        self.db_config = db_config
        self.conn = None
        self.cur = None

    def connect(self):
        """Establish database connection"""
        try:
            self.conn = psycopg2.connect(**self.db_config)
            self.cur = self.conn.cursor()
        except Exception as e:
            print(f"Connection error: {e}")
            raise

    def close(self):
        """Close database connection"""
        if self.cur:
            self.cur.close()
        if self.conn:
            self.conn.close()

    def delete_specific_records(self):
        """Delete specific records from the database"""
        try:
            self.connect()
            
            # First delete the camera (no dependencies)
            print("Deleting camera with ID 6...")
            self.cur.execute("DELETE FROM cameras WHERE camera_id = 6")
            camera_deleted = self.cur.rowcount
            print(f"Deleted {camera_deleted} camera(s)")
            
            # Then delete the area that references the zone
            print("Deleting area with ID 5...")
            self.cur.execute("DELETE FROM areas WHERE area_id = 5")
            area_deleted = self.cur.rowcount
            print(f"Deleted {area_deleted} area(s)")
            
            # Finally delete the zone (after its references are gone)
            print("Deleting zone with ID 5...")
            self.cur.execute("DELETE FROM zones WHERE zone_id = 5")
            zone_deleted = self.cur.rowcount
            print(f"Deleted {zone_deleted} zone(s)")
            
            # Commit the transaction
            self.conn.commit()
            print("Specific records deleted successfully")
            
            # Verify deletions
            print("\nVerifying deletions...")
            self.cur.execute("SELECT COUNT(*) FROM cameras WHERE camera_id = 6")
            print(f"Remaining cameras with ID 6: {self.cur.fetchone()[0]}")
            self.cur.execute("SELECT COUNT(*) FROM areas WHERE area_id = 5")
            print(f"Remaining areas with ID 5: {self.cur.fetchone()[0]}")
            self.cur.execute("SELECT COUNT(*) FROM zones WHERE zone_id = 5")
            print(f"Remaining zones with ID 5: {self.cur.fetchone()[0]}")
            
        except Exception as e:
            print(f"Error during deletion: {e}")
            self.conn.rollback()
        finally:
            self.close()

if __name__ == "__main__":
    # Initialize and run the cleaner
    cleaner = SpecificRecordCleaner(DB_CONFIG)
    cleaner.delete_specific_records()