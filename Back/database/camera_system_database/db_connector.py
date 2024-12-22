# Back/camera_system_database/database/db_connector.py
import psycopg2
from psycopg2.extras import DictCursor
import logging
from typing import Dict, List, Optional
from contextlib import contextmanager

class DatabaseConnector:
    def __init__(self, dbname="camera_db", user="your_user", password="your_password", host="localhost", port="5432"):
        self.conn_params = {
            "dbname": dbname,
            "user": user,
            "password": password,
            "host": host,
            "port": port
        }
        self.logger = logging.getLogger(__name__)
        
        # Test connection on initialization
        self._test_connection()

    def _test_connection(self):
        """Test database connection on startup"""
        try:
            with self.get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT 1")
            self.logger.info("Database connection successful")
        except Exception as e:
            self.logger.error(f"Database connection failed: {str(e)}")
            raise

    @contextmanager
    def get_connection(self):
        """Context manager for database connections"""
        conn = None
        try:
            conn = psycopg2.connect(**self.conn_params)
            yield conn
        finally:
            if conn is not None:
                conn.close()

    def get_camera_config(self) -> Optional[Dict]:
        """Get global camera configuration"""
        try:
            with self.get_connection() as conn:
                with conn.cursor(cursor_factory=DictCursor) as cur:
                    cur.execute("""
                        SELECT 
                            resize_scale,
                            reconnect_delay,
                            max_retries,
                            status_update_interval,
                            frame_rate
                        FROM camera_config 
                        ORDER BY config_id DESC 
                        LIMIT 1
                    """)
                    config = cur.fetchone()
                    return dict(config) if config else None
        except Exception as e:
            self.logger.error(f"Error fetching camera config: {str(e)}")
            raise

    def get_enabled_cameras(self):
        """Get all enabled cameras with zone and area information"""
        try:
            with self.get_connection() as conn:
                with conn.cursor(cursor_factory=DictCursor) as cur:
                    query = """
                        SELECT 
                            c.camera_id,
                            z.zone_name as name,
                            a.area_name,
                            c.ip_address as ip,
                            c.port,
                            c.username,
                            c.password,
                            c.channel,
                            c.capacities,
                            c.enabled
                        FROM cameras c
                        JOIN areas a ON c.area_id = a.area_id
                        JOIN zones z ON a.zone_id = z.zone_id
                        WHERE c.enabled = true
                    """
                    cur.execute(query)
                    cameras = [dict(row) for row in cur.fetchall()]
                    return cameras
        except Exception as e:
            self.logger.error(f"Error fetching enabled cameras: {str(e)}")
            raise

    def update_camera_status(self, camera_id: int, enabled: bool) -> bool:
        """Update camera enabled status"""
        try:
            with self.get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute("""
                        UPDATE cameras 
                        SET enabled = %s, updated_at = CURRENT_TIMESTAMP
                        WHERE camera_id = %s
                    """, (enabled, camera_id))
                    conn.commit()
                    return cur.rowcount > 0
        except Exception as e:
            self.logger.error(f"Error updating camera status: {str(e)}")
            raise

