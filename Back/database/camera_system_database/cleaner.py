import psycopg2
from typing import Dict
from db_config import DB_CONFIG

class DatabaseCleaner:
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

    def empty_tables(self):
        """Empty all tables in the camera_system database"""
        try:
            self.connect()
            
            # Disable triggers temporarily to avoid any trigger-related issues
            self.cur.execute("SET session_replication_role = 'replica';")
            
            # Order matters due to potential foreign key relationships
            # We'll truncate tables in reverse dependency order
            tables = [
                'camera_config',  # Configuration table first
                'cameras',        # Cameras table
                'areas',          # Areas table
                'zones'          # Zones table last
            ]
            
            for table in tables:
                print(f"Emptying table: {table}")
                # Using TRUNCATE CASCADE to handle any foreign key relationships
                self.cur.execute(f"TRUNCATE TABLE {table} CASCADE;")
                print(f"Table {table} emptied successfully")
            
            # Re-enable triggers
            self.cur.execute("SET session_replication_role = 'origin';")
            
            # Commit the transaction
            self.conn.commit()
            print("\nAll tables emptied successfully")
            
            # Verify that tables are empty
            print("\nVerifying empty tables:")
            for table in tables:
                self.cur.execute(f"SELECT COUNT(*) FROM {table}")
                count = self.cur.fetchone()[0]
                print(f"{table}: {count} records")
                
        except Exception as e:
            print(f"Error during table cleanup: {e}")
            self.conn.rollback()
        finally:
            self.close()

if __name__ == "__main__":
    # Initialize and run the cleaner
    cleaner = DatabaseCleaner(DB_CONFIG)
    cleaner.empty_tables()