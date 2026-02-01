from database.crowd_management_database.db_connector import DatabaseConnector
from datetime import datetime, timedelta
from typing import Dict, List, Any, Optional
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CrowdMeasurements:
    def __init__(self):
        self.db = DatabaseConnector.get_instance()

    def insert_crowd_data(self, measurements: List[Dict[str, Any]]) -> bool:
        """
        Insert crowd data measurements in batch
        
        Args:
            measurements: List of dictionaries containing:
                - zone: zone name
                - area: area name
                - camera_id: camera ID
                - capacity: capacity
                - number_of_people: rounded average of counts
                - crowding_level: crowding level
                - crowding_percentage: percentage
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                for data in measurements:
                    cur.execute("""
                        INSERT INTO crowd_measurements 
                        (camera_id, zone_name, area_name, capacity, 
                        number_of_people, crowding_level, crowding_percentage)
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                        """,
                        (data['camera_id'], 
                        data['zone'], 
                        data['area'],
                        data['capacity'], 
                        data['number_of_people'],  
                        data['crowding_level'], 
                        data['crowding_percentage'])
                    )
                conn.commit()
                logger.info(f"Successfully inserted {len(measurements)} measurements")
                return True
                
        except Exception as e:
            logger.error(f"Error inserting measurements: {str(e)}")
            if conn:
                conn.rollback()
                return False
        finally:
            if conn:
                self.db.return_connection(conn)
    
   
    def update_measurement(self, measurement_id: int, data: Dict[str, Any]) -> bool:
        """Update an existing measurement"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    UPDATE crowd_measurements
                    SET number_of_people = %s,
                        crowding_level = %s,
                        crowding_percentage = %s
                    WHERE measurement_id = %s
                    """,
                    (data['number_of_people'], data['crowding_level'],
                     data['crowding_percentage'], measurement_id)
                )
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"Error updating measurement: {str(e)}")
            if conn:
                conn.rollback()
            return False
        finally:
            if conn:
                self.db.return_connection(conn)
   
   
    def delete_measurement(self, measurement_id: int) -> bool:
        """Delete a measurement by ID"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    DELETE FROM crowd_measurements
                    WHERE measurement_id = %s
                    """, (measurement_id,))
                conn.commit()
                return True
        except Exception as e:
            logger.error(f"Error deleting measurement: {str(e)}")
            if conn:
                conn.rollback()
            return False
        finally:
            if conn:
                self.db.return_connection(conn)


