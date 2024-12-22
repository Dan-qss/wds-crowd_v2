from db_connector import DatabaseConnector
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def test_database_connection():
    """Test the database connection by attempting to connect and run a simple query"""
    db = None
    conn = None
    try:
        # Get database connector instance
        db = DatabaseConnector.get_instance()
        
        # Get a connection from the pool
        conn = db.get_connection()
        
        # Create a cursor and execute a simple query
        with conn.cursor() as cur:
            cur.execute("SELECT version();")
            version = cur.fetchone()
            logger.info(f"Successfully connected to PostgreSQL. Version: {version[0]}")
            
        return True
        
    except Exception as e:
        logger.error(f"Error connecting to the database: {str(e)}")
        return False
        
    finally:
        # Always return the connection to the pool
        if conn:
            db.return_connection(conn)

if __name__ == "__main__":
    success = test_database_connection()
    if success:
        logger.info("Database connection test completed successfully")
    else:
        logger.error("Database connection test failed")