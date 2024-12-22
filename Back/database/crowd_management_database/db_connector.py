# Back/database/crowd_management_database/db_connector.py
import psycopg2
from psycopg2 import pool
import logging
import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__)))
from db_configuration import db_config
# from database.crowd_management_database.db_config import db_config


class DatabaseConnector:
    _instance = None
    _connection_pool = None
    @staticmethod
    def get_instance():
        """Singleton pattern to ensure only one connection pool exists"""
        if DatabaseConnector._instance is None:
            DatabaseConnector._instance = DatabaseConnector()
        return DatabaseConnector._instance

    def __init__(self):
        """Initialize connection pool if it doesn't exist"""
        if DatabaseConnector._connection_pool is None:
            try:
                DatabaseConnector._connection_pool = psycopg2.pool.SimpleConnectionPool(
                    minconn=1,
                    maxconn=10,
                    **db_config
                )
                logging.info("Database connection pool created successfully")
            except Exception as e:
                logging.error(f"Error creating connection pool: {str(e)}")
                raise

    def get_connection(self):
        """Get a connection from the pool"""
        return DatabaseConnector._connection_pool.getconn()

    def return_connection(self, conn):
        """Return a connection to the pool"""
        DatabaseConnector._connection_pool.putconn(conn)

    def close_all_connections(self):
        """Close all connections in the pool"""
        if DatabaseConnector._connection_pool:
            DatabaseConnector._connection_pool.closeall()
            logging.info("All database connections closed")

