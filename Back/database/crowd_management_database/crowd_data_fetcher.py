#crowd_data_fetcher.py
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "/database"))
from db_connector import DatabaseConnector
from typing import List, Dict, Any, Optional, Tuple
from datetime import datetime, timedelta
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class CrowdDataFetcher:
    def __init__(self):
        self.db = DatabaseConnector.get_instance()
    
    def get_all_zones(self) -> List[str]:
        """Fetch all unique zone names from the database"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("SELECT DISTINCT zone_name FROM crowd_measurements")
                return [row[0] for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_zone_areas(self, zone_name: str) -> List[str]:
        """Fetch all areas for a specific zone"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT DISTINCT area_name 
                    FROM crowd_measurements 
                    WHERE zone_name = %s
                    """, (zone_name,))
                return [row[0] for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_current_occupancy(self, zone_name: Optional[str] = None) -> List[Dict]:
        """
        Get current occupancy for all areas or a specific zone
        Returns latest measurement for each camera
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                query = """
                    WITH LatestMeasurements AS (
                        SELECT DISTINCT ON (camera_id) *
                        FROM crowd_measurements
                        {}
                        ORDER BY camera_id, measured_at DESC
                    )
                    SELECT * FROM LatestMeasurements
                    ORDER BY zone_name, area_name
                """
                
                where_clause = "WHERE zone_name = %s" if zone_name else ""
                query = query.format(where_clause)
                
                if zone_name:
                    cur.execute(query, (zone_name,))
                else:
                    cur.execute(query)
                
                columns = ['measurement_id', 'camera_id', 'zone_name', 'area_name',
                          'capacity', 'number_of_people', 'crowding_level',
                          'crowding_percentage', 'measured_at']
                return [dict(zip(columns, row)) for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_peak_hours(self, zone_name: str, days: int = 7) -> List[Dict]:
        """
        Get peak hours for a zone based on historical data
        Returns average occupancy by hour of day
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        EXTRACT(HOUR FROM measured_at) as hour,
                        AVG(number_of_people) as avg_people,
                        AVG(crowding_percentage) as avg_percentage,
                        MAX(number_of_people) as max_people,
                        MAX(crowding_percentage) as max_percentage
                    FROM crowd_measurements
                    WHERE zone_name = %s
                    AND measured_at >= NOW() - INTERVAL '%s days'
                    GROUP BY EXTRACT(HOUR FROM measured_at)
                    ORDER BY hour
                """, (zone_name, days))
                
                return [{
                    'hour': int(row[0]),
                    'avg_people': round(row[1], 2),
                    'avg_percentage': round(row[2], 2),
                    'max_people': int(row[3]),
                    'max_percentage': round(row[4], 2)
                } for row in cur.fetchall()]
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_occupancy_summary(self, zone_name: Optional[str] = None) -> Dict[str, Any]:
        """Get current occupancy summary statistics"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                where_clause = "WHERE zone_name = %s" if zone_name else ""
                query = f"""
                    SELECT 
                        COUNT(DISTINCT camera_id) as total_cameras,
                        SUM(capacity) as total_capacity,
                        SUM(number_of_people) as total_people,
                        ROUND(AVG(crowding_percentage), 2) as avg_occupancy
                    FROM (
                        SELECT DISTINCT ON (camera_id) *
                        FROM crowd_measurements
                        {where_clause}
                        ORDER BY camera_id, measured_at DESC
                    ) latest
                """
                
                if zone_name:
                    cur.execute(query, (zone_name,))
                else:
                    cur.execute(query)
                    
                row = cur.fetchone()
                return {
                    'total_cameras': row[0],
                    'total_capacity': row[1],
                    'total_people': row[2],
                    'avg_occupancy': row[3]
                }
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_data_by_time_range(self, start_time: str, end_time: str) -> List[Dict]:
        """
        Get specific measurements between two timestamps
        
        Args:
            start_time (str): Start time in format 'YYYY-MM-DD HH:MM'
            end_time (str): End time in format 'YYYY-MM-DD HH:MM'
        
        Returns:
            List[Dict]: List of measurements with specific fields between the specified times
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                query = """
                    SELECT camera_id, zone_name, number_of_people, crowding_level, crowding_percentage
                    FROM crowd_measurements
                    WHERE measured_at BETWEEN %s::timestamp AND %s::timestamp
                    ORDER BY measured_at ASC
                """
                cur.execute(query, (start_time, end_time))

                columns = ['camera_id', 'zone_name', 'number_of_people', 'crowding_level', 'crowding_percentage']
                results = [dict(zip(columns, row)) for row in cur.fetchall()]

                return {
                    'total_records': len(results),
                    'time_range': {'start_time': start_time, 'end_time': end_time},
                    'data': results
                }

        except Exception as e:
            logger.error(f"Error fetching data by time range: {str(e)}")
            # ✅ Return empty 200-style response, not None
            return {
                'total_records': 0,
                'time_range': {'start_time': start_time, 'end_time': end_time},
                'data': []
            }
        finally:
            if conn:
                self.db.return_connection(conn)


    # Add this method to your CrowdDataFetcher class
    def get_occupancy_percentages_by_zone(self, start_time: str, end_time: str, table_name: Optional[str] = None) -> Dict:
        """
        Get occupancy percentages aggregated by zones from a specific table
        
        Args:
            start_time: Start time string
            end_time: End time string  
            table_name: Optional specific table name (e.g., 'crowd_data_01_2025')
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                table_to_query = table_name if table_name else "crowd_measurements"

                query = f"""
                    SELECT 
                        zone_name,
                        area_name,
                        camera_id,
                        AVG(number_of_people) as avg_people,
                        AVG(crowding_percentage) as avg_percentage,
                        AVG(capacity) as avg_capacity,
                        COUNT(*) as measurement_count
                    FROM {table_to_query}
                    WHERE measured_at BETWEEN %s AND %s
                    GROUP BY zone_name, area_name, camera_id
                    ORDER BY zone_name, area_name
                """

                cur.execute(query, (start_time, end_time))
                results = cur.fetchall()

                # ✅ Empty DB / empty range -> return EMPTY response with 200
                if not results:
                    return {
                        'time_range': {'start_time': start_time, 'end_time': end_time},
                        'total_zones': 0,
                        'total_cameras': 0,
                        'zone_data': [],
                        'camera_data': [],
                        'chart_data': {'labels': [], 'values': [], 'absolute_values': []}
                    }

                zone_data = {}
                camera_data = []

                for row in results:
                    zone_name = row[0]
                    area_name = row[1]
                    camera_id = row[2]
                    avg_people = float(row[3]) if row[3] else 0.0
                    avg_percentage = float(row[4]) if row[4] else 0.0
                    avg_capacity = float(row[5]) if row[5] else 0.0

                    if zone_name not in zone_data:
                        zone_data[zone_name] = {
                            'zone_name': zone_name,
                            'total_people': 0.0,
                            'total_capacity': 0.0,
                            'avg_percentage': 0.0,
                            'camera_count': 0
                        }

                    zone_data[zone_name]['total_people'] += avg_people
                    zone_data[zone_name]['total_capacity'] += avg_capacity
                    zone_data[zone_name]['camera_count'] += 1

                    camera_data.append({
                        'camera_id': camera_id,
                        'zone_name': zone_name,
                        'area_name': area_name,
                        'avg_people': round(avg_people, 1),
                        'avg_percentage': round(avg_percentage, 1),
                        'capacity': int(avg_capacity) if avg_capacity else 0
                    })

                chart_labels = []
                chart_values = []
                chart_absolute_values = []

                zones_list = list(zone_data.values())
                for zone in zones_list:
                    if zone['total_capacity'] > 0:
                        zone['avg_percentage'] = (zone['total_people'] / zone['total_capacity']) * 100
                    else:
                        zone['avg_percentage'] = 0.0

                    chart_labels.append(zone['zone_name'])
                    chart_values.append(round(zone['avg_percentage'], 1))
                    chart_absolute_values.append(round(zone['total_people'], 1))

                return {
                    'time_range': {'start_time': start_time, 'end_time': end_time},
                    'total_zones': len(zones_list),
                    'total_cameras': len(camera_data),
                    'zone_data': zones_list,
                    'camera_data': camera_data,
                    'chart_data': {
                        'labels': chart_labels,
                        'values': chart_values,
                        'absolute_values': chart_absolute_values
                    }
                }

        except Exception as e:
            logger.error(f"Error getting zone occupancy percentages: {str(e)}")
            # ✅ Return empty response instead of None
            return {
                'time_range': {'start_time': start_time, 'end_time': end_time},
                'total_zones': 0,
                'total_cameras': 0,
                'zone_data': [],
                'camera_data': [],
                'chart_data': {'labels': [], 'values': [], 'absolute_values': []}
            }
        finally:
            if conn:
                self.db.return_connection(conn)
    def get_latest_by_camera(self, camera_id: int) -> Optional[Dict]:
        """Get the latest measurement for a specific camera"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT *
                    FROM crowd_measurements
                    WHERE camera_id = %s
                    ORDER BY measured_at DESC
                    LIMIT 1
                    """, (camera_id,))
                result = cur.fetchone()
                if result:
                    columns = ['measurement_id', 'camera_id', 'zone_name', 'area_name',
                             'capacity', 'number_of_people', 'crowding_level',
                             'crowding_percentage', 'measured_at']
                    return dict(zip(columns, result))
                return None
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_zone_stats(self, zone_name: str, hours: int = 24) -> Dict:
        """Get statistics for a specific zone"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        AVG(number_of_people) as avg_people,
                        MAX(number_of_people) as max_people,
                        AVG(crowding_percentage) as avg_percentage,
                        MAX(crowding_percentage) as max_percentage
                    FROM crowd_measurements
                    WHERE zone_name = %s
                    AND measured_at >= NOW() - INTERVAL '%s hours'
                    """, (zone_name, hours))
                result = cur.fetchone()
                if result:
                    return {
                        'avg_people': round(result[0] if result[0] else 0, 2),
                        'max_people': round(result[1] if result[1] else 0, 2),
                        'avg_percentage': round(result[2] if result[2] else 0, 2),
                        'max_percentage': round(result[3] if result[3] else 0, 2)
                    }
                return None
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_hourly_averages(self, zone_name: str, date: datetime) -> List[Dict]:
        """Get hourly averages for a specific zone and date"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT 
                        DATE_TRUNC('hour', measured_at) as hour,
                        AVG(number_of_people) as avg_people,
                        AVG(crowding_percentage) as avg_percentage
                    FROM crowd_measurements
                    WHERE zone_name = %s
                    AND DATE(measured_at) = DATE(%s)
                    GROUP BY DATE_TRUNC('hour', measured_at)
                    ORDER BY hour
                    """, (zone_name, date))
                return [
                    {
                        'hour': row[0],
                        'avg_people': round(row[1], 2),
                        'avg_percentage': round(row[2], 2)
                    }
                    for row in cur.fetchall()
                ]
        finally:
            if conn:
                self.db.return_connection(conn)
    
    def get_measurement_by_id(self, measurement_id: int) -> Optional[Dict]:
        """Get a specific measurement by ID"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT measurement_id, camera_id, zone_name, area_name, 
                           capacity, number_of_people, crowding_level, 
                           crowding_percentage, measured_at
                    FROM crowd_measurements
                    WHERE measurement_id = %s
                    """, (measurement_id,))
                result = cur.fetchone()
                if result:
                    columns = ['measurement_id', 'camera_id', 'zone_name', 'area_name',
                             'capacity', 'number_of_people', 'crowding_level',
                             'crowding_percentage', 'measured_at']
                    return dict(zip(columns, result))
                return None
        except Exception as e:
            logger.error(f"Error retrieving measurement: {str(e)}")
            return None
        finally:
            if conn:
                self.db.return_connection(conn)

