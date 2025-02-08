import psycopg2
from typing import List, Dict
from db_config import DB_CONFIG

class CameraFieldUpdater:
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

    def update_camera_fields(self, updates: List[Dict]):
        """Update area_id and capacities for specified cameras"""
        try:
            for update in updates:
                self.cur.execute("""
                    UPDATE cameras 
                    SET area_id = %s, 
                        capacities = %s,
                        updated_at = CURRENT_TIMESTAMP
                    WHERE camera_id = %s
                """, (
                    update['area_id'],
                    update['capacities'],
                    update['camera_id']
                ))
                print(f"Updated camera ID {update['camera_id']}")
            
            self.conn.commit()
            print("Updates completed successfully")
        except psycopg2.Error as e:
            print(f"Error updating camera fields: {e}")
            self.conn.rollback()

if __name__ == "__main__":
    # Sample updates - modify these values according to your needs
    camera_updates = [
        {"camera_id": 8, "area_id": 12, "capacities": 10},
        {"camera_id": 9, "area_id": 13, "capacities": 10},
        {"camera_id": 10, "area_id": 14, "capacities": 10},
        {"camera_id": 11, "area_id": 15, "capacities": 10},
        {"camera_id": 12, "area_id": 16, "capacities": 10}
    ]

    # Initialize the updater and perform updates
    try:
        updater = CameraFieldUpdater(DB_CONFIG)
        updater.connect()
        updater.update_camera_fields(camera_updates)
    except Exception as e:
        print(f"Error: {e}")
    finally:
        updater.close()