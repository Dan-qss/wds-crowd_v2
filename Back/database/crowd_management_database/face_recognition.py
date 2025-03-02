# /Back/database/crowd_management_database/face_recognition.py
import logging
from db_connector import DatabaseConnector

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class FaceRecognitionCRUD:
    def __init__(self):
        self.db_connector = DatabaseConnector.get_instance()

    def insert_record(self, zone, camera_id, person_name, position, status, timestamp):
        """Insert a new record into the face_recognition table."""
        query = """
        INSERT INTO face_recognition (zone, camera_id, person_name, position, status, timestamp)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        params = (zone, camera_id, person_name, position, status, timestamp)
        conn = None
        try:
            conn = self.db_connector.get_connection()
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                conn.commit()
                logger.info(f"Record inserted successfully: {params}")
        except Exception as e:
            logger.error(f"Error inserting record: {e}")
            if conn:
                conn.rollback()
        finally:
            if conn:
                self.db_connector.return_connection(conn)

    def update_record(self, person_name, new_status, new_position):
        """Update the status and position of a record based on the person's name."""
        query = """
        UPDATE face_recognition
        SET status = %s, position = %s
        WHERE person_name = %s
        """
        params = (new_status, new_position, person_name)
        conn = None
        try:
            conn = self.db_connector.get_connection()
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                conn.commit()
                logger.info(f"Record updated successfully for {person_name}: {params}")
        except Exception as e:
            logger.error(f"Error updating record: {e}")
            if conn:
                conn.rollback()
        finally:
            if conn:
                self.db_connector.return_connection(conn)

    def delete_record(self, person_name):
        """Delete a record from the face_recognition table based on the person's name."""
        query = """
        DELETE FROM face_recognition
        WHERE person_name = %s
        """
        params = (person_name,)
        conn = None
        try:
            conn = self.db_connector.get_connection()
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                conn.commit()
                logger.info(f"Record deleted successfully for {person_name}")
        except Exception as e:
            logger.error(f"Error deleting record: {e}")
            if conn:
                conn.rollback()
        finally:
            if conn:
                self.db_connector.return_connection(conn)

    def fetch_all_records(self):
        """Fetch all records from the face_recognition table."""
        query = """
        SELECT * FROM face_recognition
        """
        conn = None
        try:
            conn = self.db_connector.get_connection()
            with conn.cursor() as cursor:
                cursor.execute(query)
                records = cursor.fetchall()
                logger.info("Fetched all records successfully")
                return records
        except Exception as e:
            logger.error(f"Error fetching records: {e}")
            return None
        finally:
            if conn:
                self.db_connector.return_connection(conn)

    def fetch_records(self, zone, person_name, start_time, end_time):
        """Fetch records for a specific person in a specific zone within a time window."""
        query = """
        SELECT * FROM face_recognition
        WHERE zone = %s AND person_name = %s AND timestamp BETWEEN %s AND %s
        """
        params = (zone, person_name, start_time, end_time)
        conn = None
        try:
            conn = self.db_connector.get_connection()
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                records = cursor.fetchall()
                return records
        except Exception as e:
            logger.error(f"Error fetching records: {e}")
            return None
        finally:
            if conn:
                self.db_connector.return_connection(conn)
    

class UnknownRecognitionCRUD:
    def __init__(self):
        self.db_connector = DatabaseConnector.get_instance()

    def insert_record(self, zone_name, camera_id, timestamp, gender, age):
        """
        Insert a new record into the unknown_recognition table.
        
        Parameters:
        zone_name (str): Name of the zone where person was detected
        camera_id (int): ID of the camera that captured the person
        timestamp (datetime): Time when the person was detected
        gender (str): Detected gender of the person
        age (int): Estimated age of the person
        """
        query = """
        INSERT INTO unknown_recognition (zone_name, camera_id, timestamp, gender, age)
        VALUES (%s, %s, %s, %s, %s)
        """
        params = (zone_name, camera_id, timestamp, gender, age)
        conn = None
        try:
            conn = self.db_connector.get_connection()
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                conn.commit()
                logger.info(f"Unknown person record inserted successfully: {params}")
        except Exception as e:
            logger.error(f"Error inserting unknown person record: {e}")
            if conn:
                conn.rollback()
        finally:
            if conn:
                self.db_connector.return_connection(conn)

    def fetch_records_by_zone_gender_age(self, zone_name, gender, age, start_time, end_time):
        """
        Fetch unknown person records for a specific zone, gender, and age within a time window.
        
        Parameters:
        zone_name (str): Name of the zone to fetch records from
        gender (str): Gender of the person
        age (int): Age of the person
        start_time (datetime): Start of the time window
        end_time (datetime): End of the time window
        
        Returns:
        list: List of records matching the criteria
        """
        query = """
        SELECT * FROM unknown_recognition
        WHERE zone_name = %s AND timestamp BETWEEN %s AND %s
        """
        params = (zone_name, start_time, end_time)
        conn = None
        try:
            conn = self.db_connector.get_connection()
            with conn.cursor() as cursor:
                cursor.execute(query, params)
                records = cursor.fetchall()
                return records
        except Exception as e:
            logger.error(f"Error fetching unknown person records: {e}")
            return None
        finally:
            if conn:
                self.db_connector.return_connection(conn)