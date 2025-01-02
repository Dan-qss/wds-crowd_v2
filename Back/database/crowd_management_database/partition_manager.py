import logging
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from database.crowd_management_database.db_connector import DatabaseConnector
from datetime import datetime, timedelta

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class PartitionManager:
    def __init__(self):
        self.db = DatabaseConnector.get_instance()

    def create_next_month_partition(self) -> bool:
        """Create partition for the next month"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                # Calculate next month's date
                next_month = datetime.now().replace(day=1) + timedelta(days=32)
                next_month = next_month.replace(day=1)
                
                # Generate partition name (e.g., crowd_data_01_2025)
                partition_name = f"crowd_data_{next_month.strftime('%m_%Y')}"
                
                # Calculate range bounds
                start_range = next_month.strftime('%Y-%m-%d 00:00:00')
                end_range = (next_month + timedelta(days=32)).replace(day=1).strftime('%Y-%m-%d 00:00:00')
                
                # Create the partition
                cur.execute(f"""
                    CREATE TABLE IF NOT EXISTS {partition_name}
                    PARTITION OF crowd_measurements
                    FOR VALUES FROM ('{start_range}') TO ('{end_range}')
                """)
                
                conn.commit()
                logger.info(f"Successfully created partition {partition_name}")
                return True
                
        except Exception as e:
            logger.error(f"Error creating partition: {str(e)}")
            if conn:
                conn.rollback()
            return False
        finally:
            if conn:
                self.db.return_connection(conn)

    def check_existing_partitions(self) -> list:
        """Check existing partition tables"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT tablename 
                    FROM pg_tables 
                    WHERE tablename LIKE 'crowd_data_%'
                    ORDER BY tablename
                """)
                return [row[0] for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)