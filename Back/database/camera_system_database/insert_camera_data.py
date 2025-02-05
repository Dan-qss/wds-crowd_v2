import psycopg2
from typing import List, Dict
from db_config import DB_CONFIG

class CameraSystemInitializer:
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

    def insert_zones(self, zones: List[Dict[str, str]]) -> Dict[str, int]:
        """Insert zones and return a mapping of zone names to their IDs"""
        zone_mapping = {}
        for zone in zones:
            try:
                self.cur.execute(
                    "INSERT INTO zones (zone_name) VALUES (%s) RETURNING zone_id",
                    (zone['name'],)
                )
                zone_id = self.cur.fetchone()[0]
                zone_mapping[zone['name']] = zone_id
            except psycopg2.Error as e:
                print(f"Error inserting zone {zone['name']}: {e}")
                self.conn.rollback()
                continue
        return zone_mapping

    def insert_areas(self, areas: List[Dict], zone_mapping: Dict[str, int]) -> Dict[str, int]:
        """Insert areas and return a mapping of area names to their IDs"""
        area_mapping = {}
        for area in areas:
            try:
                zone_id = zone_mapping[area['zone_name']]
                self.cur.execute(
                    "INSERT INTO areas (zone_id, area_name) VALUES (%s, %s) RETURNING area_id",
                    (zone_id, area['name'])
                )
                area_id = self.cur.fetchone()[0]
                area_mapping[area['name']] = area_id
            except psycopg2.Error as e:
                print(f"Error inserting area {area['name']}: {e}")
                self.conn.rollback()
                continue
        return area_mapping

    def insert_cameras(self, cameras: List[Dict], area_mapping: Dict[str, int]):
        """Insert cameras"""
        for camera in cameras:
            try:
                self.cur.execute("""
                    INSERT INTO cameras (
                        area_id, ip_address, port, username, password,
                        channel, rtsp_url, capacities, enabled
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                """, (
                    area_mapping[camera['area_name']],
                    camera['ip'],
                    camera['port'],
                    camera['username'],
                    camera['password'],
                    camera['channel'],
                    camera['rtsp_url'],
                    camera['capacities'],
                    camera.get('enabled', True)
                ))
            except psycopg2.Error as e:
                print(f"Error inserting camera {camera['ip']}: {e}")
                self.conn.rollback()
                continue

    def insert_camera_config(self, config: Dict):
        """Insert camera configuration"""
        try:
            self.cur.execute("""
                INSERT INTO camera_config (
                    resize_scale, reconnect_delay, max_retries,
                    status_update_interval, frame_rate
                ) VALUES (%s, %s, %s, %s, %s)
            """, (
                config['resize_scale'],
                config['reconnect_delay'],
                config['max_retries'],
                config['status_update_interval'],
                config['frame_rate']
            ))
        except psycopg2.Error as e:
            print(f"Error inserting camera config: {e}")
            self.conn.rollback()

    def initialize_data(self, zones, areas, cameras, ):
        """Initialize all data in the correct order"""
        try:
            self.connect()
            zone_mapping = self.insert_zones(zones)
            area_mapping = self.insert_areas(areas, zone_mapping)
            self.insert_cameras(cameras, area_mapping)
            self.conn.commit()
            print("Data initialization completed successfully")
        except Exception as e:
            print(f"Error during initialization: {e}")
            self.conn.rollback()
        finally:
            self.close()

# Example usage
if __name__ == "__main__":
    # Sample data
    zones_data = [
        {"name": "software_lab1"}
    ]

    areas_data = [
        {"name": "main_area", "zone_name": "software_lab1"}
    ]

    cameras_data = [
        {
            "area_name": "main_area",
            "ip": "192.168.100.208",
            "port": "80",
            "username": "admin",
            "password": "QSS2030QSS",
            "channel": "101",
            "rtsp_url": "rtsp://admin:QSS2030QSS@192.168.100.208/Streaming/Channels/101",
            "capacities": 9,
            "enabled": True
        }
    ]



    # Initialize the database
    initializer = CameraSystemInitializer(DB_CONFIG)
    initializer.initialize_data(zones_data, areas_data, cameras_data)