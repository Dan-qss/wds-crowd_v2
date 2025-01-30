import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "/database"))
from db_connector import DatabaseConnector
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class FaceRecognitionFetcher:
    def __init__(self):
        self.db = DatabaseConnector.get_instance()
   
    def get_latest_recognitions(self, zone: Optional[str] = None) -> List[Dict]:
        """
        Get latest face recognition entries for all zones or a specific zone
        Returns latest entry for each person
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                query = """
                    WITH LatestRecognitions AS (
                        SELECT DISTINCT ON (person_name) *
                        FROM face_recognition
                        {}
                        ORDER BY person_name, timestamp DESC
                    )
                    SELECT * FROM LatestRecognitions
                    ORDER BY timestamp DESC
                """
                
                where_clause = "WHERE zone = %s" if zone else ""
                query = query.format(where_clause)
                
                if zone:
                    cur.execute(query, (zone,))
                else:
                    cur.execute(query)
                
                columns = ['zone', 'camera_id', 'person_name', 'position', 
                          'status', 'timestamp']
                return [dict(zip(columns, row)) for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_person_history(self, person_name: str, hours: int = 24) -> List[Dict]:
        """Get recognition history for a specific person"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT *
                    FROM face_recognition
                    WHERE person_name = %s
                    AND timestamp >= NOW() - INTERVAL '%s hours'
                    ORDER BY timestamp DESC
                    """, (person_name, hours))
                
                columns = ['zone', 'camera_id', 'person_name', 'position', 
                          'status', 'timestamp']
                return [dict(zip(columns, row)) for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_status_distribution(self, zone: Optional[str] = None, 
                              hours: int = 1) -> List[Dict]:
        """Get distribution of status values"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                query = """
                    SELECT 
                        status,
                        COUNT(*) as count,
                        COUNT(DISTINCT person_name) as unique_people
                    FROM face_recognition
                    WHERE timestamp >= NOW() - INTERVAL '%s hours'
                    {}
                    GROUP BY status
                    ORDER BY count DESC
                """
                
                where_clause = "AND zone = %s" if zone else ""
                query = query.format(where_clause)
                
                if zone:
                    cur.execute(query, (hours, zone))
                else:
                    cur.execute(query, (hours,))
                
                return [{
                    'status': row[0],
                    'count': row[1],
                    'unique_people': row[2]
                } for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def search_person(self, query: str) -> List[Dict]:
        """Search for a person by name (partial match)"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    WITH LatestSighting AS (
                        SELECT DISTINCT ON (person_name) *
                        FROM face_recognition
                        WHERE person_name ILIKE %s
                        ORDER BY person_name, timestamp DESC
                    )
                    SELECT * FROM LatestSighting
                    ORDER BY timestamp DESC
                    """, (f"%{query}%",))
                
                columns = ['zone', 'camera_id', 'person_name', 'position', 
                          'status', 'timestamp']
                return [dict(zip(columns, row)) for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_position_summary(self, zone: Optional[str] = None) -> List[Dict]:
        """Get summary of people positions"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                query = """
                    WITH LatestPositions AS (
                        SELECT DISTINCT ON (person_name) *
                        FROM face_recognition
                        {}
                        ORDER BY person_name, timestamp DESC
                    )
                    SELECT 
                        position,
                        COUNT(*) as count
                    FROM LatestPositions
                    GROUP BY position
                    ORDER BY count DESC
                """
                
                where_clause = "WHERE zone = %s" if zone else ""
                query = query.format(where_clause)
                
                if zone:
                    cur.execute(query, (zone,))
                else:
                    cur.execute(query)
                
                return [{
                    'position': row[0],
                    'count': row[1]
                } for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)
    
    def get_all_records(self, limit: Optional[int] = None, offset: Optional[int] = 0) -> List[Dict]:
        """
        Fetch all face recognition records from the database with optional pagination
        
        Args:
            limit (Optional[int]): Maximum number of records to return. None means no limit.
            offset (Optional[int]): Number of records to skip before starting to return records.
        
        Returns:
            List[Dict]: List of face recognition records with all fields
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                query = """
                    SELECT *
                    FROM face_recognition
                    ORDER BY timestamp DESC
                    """
                
                if limit is not None:
                    query += " LIMIT %s OFFSET %s"
                    cur.execute(query, (limit, offset))
                else:
                    cur.execute(query)
                
                columns = ['zone', 'camera_id', 'person_name', 'position', 
                        'status', 'timestamp']
                return [dict(zip(columns, row)) for row in cur.fetchall()]
        except Exception as e:
            logger.error(f"Error fetching all records: {str(e)}")
            raise
        finally:
            if conn:
                self.db.return_connection(conn)
                
    def get_status_stats(self) -> Dict:
        """
        Get status statistics with counts and percentages
        Returns data formatted for pie chart visualization
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                # Get counts for each status
                cur.execute("""
                    SELECT 
                        status,
                        COUNT(*) as count
                    FROM face_recognition
                    GROUP BY status
                    ORDER BY count DESC
                """)
                
                results = cur.fetchall()
                total = sum(row[1] for row in results)
                
                # Format data for pie chart
                return {
                    'labels': [row[0] for row in results],
                    'values': [round((row[1] / total) * 100, 1) for row in results],
                    'absolute_values': [row[1] for row in results]
                }
                
        except Exception as e:
            logger.error(f"Error getting status stats: {str(e)}")
            raise
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_last_n_records(self, n: int) -> List[Dict]:
            """
            Fetch the last N face recognition records from the database
            
            Args:
                n (int): Number of last records to return
                
            Returns:
                List[Dict]: List of last N face recognition records
            """
            conn = None
            try:
                conn = self.db.get_connection()
                with conn.cursor() as cur:
                    query = """
                        SELECT *
                        FROM face_recognition
                        ORDER BY timestamp DESC
                        LIMIT %s
                    """
                    
                    cur.execute(query, (n,))
                    
                    columns = ['zone', 'camera_id', 'person_name', 'position', 
                            'status', 'timestamp']
                    return [dict(zip(columns, row)) for row in cur.fetchall()]
            except Exception as e:
                logger.error(f"Error fetching last {n} records: {str(e)}")
                raise
            finally:
                if conn:
                    self.db.return_connection(conn)
    