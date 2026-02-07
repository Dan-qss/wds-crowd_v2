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

    def get_peak_so_far_today_all_zones(
        self,
        start_hour: int = 8,
        end_hour: int = 19
    ) -> Dict[str, Any]:
        """
        Peak so far (today) across ALL zones.
        Returns the hour (0-23) with the highest average crowding_percentage
        between today start_hour and now (capped at end_hour).
        """
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                now = datetime.now()

                # start = اليوم 08:00
                start_dt = now.replace(hour=start_hour, minute=0, second=0, microsecond=0)

                # end = الآن بس مقصوص على 19:00
                end_dt = now.replace(hour=end_hour, minute=0, second=0, microsecond=0)
                if now < end_dt:
                    end_dt = now

                # إذا قبل وقت الافتتاح (قبل 08:00) رجّعي فاضي
                if end_dt <= start_dt:
                    return {
                        "date": start_dt.strftime("%Y-%m-%d"),
                        "range": {
                            "start_time": start_dt.strftime("%Y-%m-%d %H:%M"),
                            "end_time": end_dt.strftime("%Y-%m-%d %H:%M"),
                        },
                        "peak_hour": None,
                        "peak_avg_percentage": None
                    }

                cur.execute("""
                    SELECT
                        EXTRACT(HOUR FROM measured_at) AS hour,
                        AVG(crowding_percentage) AS avg_percentage
                    FROM crowd_measurements
                    WHERE measured_at >= %s
                    AND measured_at <= %s
                    GROUP BY EXTRACT(HOUR FROM measured_at)
                    ORDER BY avg_percentage DESC
                    LIMIT 1
                """, (start_dt, end_dt))

                row = cur.fetchone()
                if not row:
                    return {
                        "date": start_dt.strftime("%Y-%m-%d"),
                        "range": {
                            "start_time": start_dt.strftime("%Y-%m-%d %H:%M"),
                            "end_time": end_dt.strftime("%Y-%m-%d %H:%M"),
                        },
                        "peak_hour": None,
                        "peak_avg_percentage": None
                    }

                return {
                    "date": start_dt.strftime("%Y-%m-%d"),
                    "range": {
                        "start_time": start_dt.strftime("%Y-%m-%d %H:%M"),
                        "end_time": end_dt.strftime("%Y-%m-%d %H:%M"),
                    },
                    "peak_hour": int(row[0]),
                    "peak_avg_percentage": round(float(row[1] or 0.0), 2)
                }

        except Exception as e:
            logger.error(f"Error getting peak so far today: {str(e)}")
            return {
                "date": datetime.now().strftime("%Y-%m-%d"),
                "range": {"start_time": None, "end_time": None},
                "peak_hour": None,
                "peak_avg_percentage": None
            }
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_hourly_breakdown_for_date(self, date_str: str) -> List[Dict]:
        """Get hourly breakdown for a specific date across all zones"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                start_time = f"{date_str} 00:00:00"
                end_time = f"{date_str} 23:59:59"
                
                cur.execute("""
                    SELECT 
                        EXTRACT(HOUR FROM measured_at) as hour,
                        COUNT(*) as measurement_count,
                        SUM(number_of_people) as total_people,
                        AVG(number_of_people) as avg_people,
                        AVG(crowding_percentage) as avg_percentage,
                        MAX(number_of_people) as max_people
                    FROM crowd_measurements
                    WHERE measured_at BETWEEN %s::timestamp AND %s::timestamp
                    GROUP BY EXTRACT(HOUR FROM measured_at)
                    ORDER BY hour
                """, (start_time, end_time))
                
                hourly_rows = cur.fetchall()
                
                cur.execute("""
                    SELECT 
                        EXTRACT(HOUR FROM measured_at) as hour,
                        MAX(total_at_time) as max_people_all_areas
                    FROM (
                        SELECT measured_at, EXTRACT(HOUR FROM measured_at) as hour, SUM(number_of_people) as total_at_time
                        FROM crowd_measurements
                        WHERE measured_at BETWEEN %s::timestamp AND %s::timestamp
                        GROUP BY measured_at, EXTRACT(HOUR FROM measured_at)
                    ) time_totals
                    GROUP BY hour
                    ORDER BY hour
                """, (start_time, end_time))
                
                max_all_areas_by_hour = {}
                for row in cur.fetchall():
                    hour = int(row[0])
                    max_all_areas_by_hour[hour] = int(row[1]) if row[1] else 0
                
                results = []
                for row in hourly_rows:
                    hour = int(row[0])
                    results.append({
                        'hour': hour,
                        'hour_label': f"{hour:02d}:00-{hour+1:02d}:00",
                        'total_people': int(row[2]) if row[2] else 0,
                        'avg_people': round(float(row[3]) if row[3] else 0, 2),
                        'avg_percentage': round(float(row[4]) if row[4] else 0, 2),
                        'max_people': max_all_areas_by_hour.get(hour, 0),
                        'measurement_count': int(row[1]) if row[1] else 0
                    })
                return results
        except Exception as e:
            logger.error(f"Error getting hourly breakdown: {str(e)}")
            return []
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_daily_summary(self, date_str: str) -> Dict:
        """Get daily summary statistics for a specific date"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                start_time = f"{date_str} 00:00:00"
                end_time = f"{date_str} 23:59:59"
                
                cur.execute("""
                    SELECT 
                        COUNT(*) as total_measurements,
                        SUM(number_of_people) as total_people,
                        AVG(number_of_people) as avg_people,
                        AVG(crowding_percentage) as avg_percentage,
                        MAX(number_of_people) as max_people,
                        MAX(crowding_percentage) as max_percentage,
                        SUM(capacity) as total_capacity
                    FROM (
                        SELECT DISTINCT ON (camera_id, DATE_TRUNC('hour', measured_at)) *
                        FROM crowd_measurements
                        WHERE measured_at BETWEEN %s::timestamp AND %s::timestamp
                        ORDER BY camera_id, DATE_TRUNC('hour', measured_at), measured_at DESC
                    ) hourly_samples
                """, (start_time, end_time))
                
                row = cur.fetchone()
                
                cur.execute("""
                    SELECT MAX(total_at_time) as max_people_all_areas
                    FROM (
                        SELECT measured_at, SUM(number_of_people) as total_at_time
                        FROM crowd_measurements
                        WHERE measured_at BETWEEN %s::timestamp AND %s::timestamp
                        GROUP BY measured_at
                    ) time_totals
                """, (start_time, end_time))
                
                max_all_areas_row = cur.fetchone()
                max_people_all_areas = int(max_all_areas_row[0]) if max_all_areas_row and max_all_areas_row[0] else 0
                
                if row and row[0]:
                    total_capacity = row[6] if row[6] else 0
                    total_people = row[1] if row[1] else 0
                    overall_percentage = (total_people / total_capacity * 100) if total_capacity > 0 else 0
                    
                    return {
                        'date': date_str,
                        'total_measurements': int(row[0]),
                        'total_people': int(total_people),
                        'avg_people': round(float(row[2]) if row[2] else 0, 2),
                        'avg_percentage': round(float(row[3]) if row[3] else 0, 2),
                        'max_people': max_people_all_areas,
                        'max_percentage': round(float(row[5]) if row[5] else 0, 2),
                        'total_capacity': int(total_capacity),
                        'overall_occupancy_percentage': round(overall_percentage, 2)
                    }
                return {
                    'date': date_str,
                    'total_measurements': 0,
                    'total_people': 0,
                    'avg_people': 0,
                    'avg_percentage': 0,
                    'max_people': 0,
                    'max_percentage': 0,
                    'total_capacity': 0,
                    'overall_occupancy_percentage': 0
                }
        except Exception as e:
            logger.error(f"Error getting daily summary: {str(e)}")
            return {
                'date': date_str,
                'total_measurements': 0,
                'total_people': 0,
                'avg_people': 0,
                'avg_percentage': 0,
                'max_people': 0,
                'max_percentage': 0,
                'total_capacity': 0,
                'overall_occupancy_percentage': 0
            }
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_camera_daily_stats(self, camera_id: int, date_str: str) -> Dict:
        """Get daily statistics for a specific camera"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                start_time = f"{date_str} 00:00:00"
                end_time = f"{date_str} 23:59:59"
                
                cur.execute("""
                    SELECT 
                        camera_id,
                        zone_name,
                        area_name,
                        capacity,
                        COUNT(*) as total_measurements,
                        AVG(number_of_people) as avg_people,
                        MAX(number_of_people) as max_people,
                        AVG(crowding_percentage) as avg_percentage,
                        MAX(crowding_percentage) as max_percentage,
                        MODE() WITHIN GROUP (ORDER BY crowding_level) as most_common_level
                    FROM crowd_measurements
                    WHERE camera_id = %s
                    AND measured_at BETWEEN %s::timestamp AND %s::timestamp
                    GROUP BY camera_id, zone_name, area_name, capacity
                """, (camera_id, start_time, end_time))
                
                row = cur.fetchone()
                if row:
                    crowding_dist = {'Low': 0, 'Moderate': 0, 'Crowded': 0}
                    
                    cur.execute("""
                        SELECT crowding_level, COUNT(*) as count
                        FROM crowd_measurements
                        WHERE camera_id = %s
                        AND measured_at BETWEEN %s::timestamp AND %s::timestamp
                        GROUP BY crowding_level
                    """, (camera_id, start_time, end_time))
                    
                    for dist_row in cur.fetchall():
                        level = dist_row[0]
                        count = dist_row[1]
                        if level in crowding_dist:
                            crowding_dist[level] = count
                    
                    peak_hour_data = self.get_camera_peak_hour(camera_id, date_str)
                    
                    return {
                        'camera_id': camera_id,
                        'zone_name': row[1],
                        'area_name': row[2],
                        'capacity': int(row[3]),
                        'total_measurements': int(row[4]),
                        'avg_people': round(float(row[5]) if row[5] else 0, 2),
                        'max_people': int(row[6]) if row[6] else 0,
                        'avg_percentage': round(float(row[7]) if row[7] else 0, 2),
                        'max_percentage': round(float(row[8]) if row[8] else 0, 2),
                        'crowding_level_distribution': crowding_dist,
                        'peak_hour': peak_hour_data.get('peak_hour'),
                        'hourly_data': peak_hour_data.get('hourly_data', [])
                    }
                return None
        except Exception as e:
            logger.error(f"Error getting camera daily stats: {str(e)}")
            return None
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_camera_peak_hour(self, camera_id: int, date_str: str) -> Dict:
        """Get peak hour and hourly data for a camera on a specific date"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                start_time = f"{date_str} 00:00:00"
                end_time = f"{date_str} 23:59:59"
                
                cur.execute("""
                    SELECT 
                        EXTRACT(HOUR FROM measured_at) as hour,
                        AVG(number_of_people) as avg_people,
                        AVG(crowding_percentage) as avg_percentage
                    FROM crowd_measurements
                    WHERE camera_id = %s
                    AND measured_at BETWEEN %s::timestamp AND %s::timestamp
                    GROUP BY EXTRACT(HOUR FROM measured_at)
                    ORDER BY avg_percentage DESC
                    LIMIT 1
                """, (camera_id, start_time, end_time))
                
                peak_row = cur.fetchone()
                peak_hour = int(peak_row[0]) if peak_row else None
                
                cur.execute("""
                    SELECT 
                        EXTRACT(HOUR FROM measured_at) as hour,
                        AVG(number_of_people) as avg_people,
                        AVG(crowding_percentage) as avg_percentage
                    FROM crowd_measurements
                    WHERE camera_id = %s
                    AND measured_at BETWEEN %s::timestamp AND %s::timestamp
                    GROUP BY EXTRACT(HOUR FROM measured_at)
                    ORDER BY hour
                """, (camera_id, start_time, end_time))
                
                hourly_data = []
                for row in cur.fetchall():
                    hourly_data.append({
                        'hour': int(row[0]),
                        'avg_people': round(float(row[1]) if row[1] else 0, 2),
                        'avg_percentage': round(float(row[2]) if row[2] else 0, 2)
                    })
                
                return {
                    'peak_hour': peak_hour,
                    'hourly_data': hourly_data
                }
        except Exception as e:
            logger.error(f"Error getting camera peak hour: {str(e)}")
            return {'peak_hour': None, 'hourly_data': []}
        finally:
            if conn:
                self.db.return_connection(conn)

    def get_zone_daily_analysis(self, zone_name: str, date_str: str) -> Dict:
        """Get comprehensive daily analysis for a zone"""
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                start_time = f"{date_str} 00:00:00"
                end_time = f"{date_str} 23:59:59"
                
                cur.execute("""
                    SELECT 
                        COUNT(DISTINCT camera_id) as total_cameras,
                        SUM(capacity) as total_capacity,
                        COUNT(*) as total_measurements,
                        AVG(number_of_people) as avg_people,
                        MAX(number_of_people) as max_people,
                        AVG(crowding_percentage) as avg_percentage,
                        MAX(crowding_percentage) as max_percentage
                    FROM crowd_measurements
                    WHERE zone_name = %s
                    AND measured_at BETWEEN %s::timestamp AND %s::timestamp
                """, (zone_name, start_time, end_time))
                
                row = cur.fetchone()
                if not row or not row[0]:
                    return None
                
                cur.execute("""
                    SELECT 
                        EXTRACT(HOUR FROM measured_at) as hour,
                        MAX(total_at_time) as max_total
                    FROM (
                        SELECT 
                            measured_at,
                            EXTRACT(HOUR FROM measured_at) as hour,
                            SUM(number_of_people) as total_at_time
                        FROM crowd_measurements
                        WHERE zone_name = %s
                        AND measured_at BETWEEN %s::timestamp AND %s::timestamp
                        GROUP BY measured_at
                    ) time_totals
                    GROUP BY hour
                    ORDER BY max_total DESC
                    LIMIT 1
                """, (zone_name, start_time, end_time))
                
                max_hour_row = cur.fetchone()
                max_people_value = int(row[4]) if row[4] else 0
                max_people_hour = int(max_hour_row[0]) if max_hour_row and max_hour_row[0] is not None else None
                
                if max_hour_row and max_hour_row[1]:
                    max_people_value = int(max_hour_row[1])
                
                stats = {
                    'zone_name': zone_name,
                    'total_cameras': int(row[0]),
                    'total_capacity': int(row[1]) if row[1] else 0,
                    'total_measurements': int(row[2]),
                    'avg_people': round(float(row[3]) if row[3] else 0, 2),
                    'max_people': max_people_value,
                    'max_people_hour': max_people_hour,
                    'avg_percentage': round(float(row[5]) if row[5] else 0, 2),
                    'max_percentage': round(float(row[6]) if row[6] else 0, 2)
                }
                
                hourly_trend = self.get_hourly_averages(zone_name, datetime.strptime(date_str, "%Y-%m-%d"))
                peak_hours = self.get_peak_hours(zone_name, days=1)
                
                cur.execute("""
                    SELECT DISTINCT camera_id, area_name, capacity
                    FROM crowd_measurements
                    WHERE zone_name = %s
                    AND measured_at BETWEEN %s::timestamp AND %s::timestamp
                    ORDER BY camera_id
                """, (zone_name, start_time, end_time))
                
                camera_details = []
                for cam_row in cur.fetchall():
                    camera_id = cam_row[0]
                    cam_stats = self.get_camera_daily_stats(camera_id, date_str)
                    if cam_stats:
                        camera_details.append({
                            'camera_id': camera_id,
                            'area_name': cam_row[1],
                            'capacity': int(cam_row[2]),
                            'avg_people': cam_stats['avg_people'],
                            'avg_percentage': cam_stats['avg_percentage'],
                            'max_people': cam_stats['max_people'],
                            'measurement_count': cam_stats['total_measurements']
                        })
                
                stats['hourly_trend'] = [
                    {
                        'hour': int(h['hour'].hour) if isinstance(h['hour'], datetime) else h['hour'],
                        'avg_people': h['avg_people'],
                        'avg_percentage': h['avg_percentage']
                    }
                    for h in hourly_trend
                ]
                stats['peak_hours'] = peak_hours[:3]
                stats['camera_details'] = camera_details
                
                return stats
        except Exception as e:
            logger.error(f"Error getting zone daily analysis: {str(e)}")
            return None
        finally:
            if conn:
                self.db.return_connection(conn)

    def generate_report_data(self, start_date: str, end_date: str, camera_names: Dict[str, str] = None) -> Dict:
        """
        Generate comprehensive report data for a date range
        
        Args:
            start_date: Start date in YYYY-MM-DD format
            end_date: End date in YYYY-MM-DD format
            camera_names: Optional dict mapping camera_id to camera name
        
        Returns:
            Dict containing complete report data
        """
        import uuid
        from datetime import datetime, timedelta
        
        report_type = "daily" if start_date == end_date else "multi_day"
        report_id = str(uuid.uuid4())
        generated_at = datetime.now().isoformat()
        
        zones = self.get_all_zones()
        all_cameras = set()
        
        conn = None
        try:
            conn = self.db.get_connection()
            with conn.cursor() as cur:
                cur.execute("""
                    SELECT DISTINCT camera_id
                    FROM crowd_measurements
                    WHERE measured_at BETWEEN %s::timestamp AND %s::timestamp
                """, (f"{start_date} 00:00:00", f"{end_date} 23:59:59"))
                all_cameras = {row[0] for row in cur.fetchall()}
        finally:
            if conn:
                self.db.return_connection(conn)
        
        total_cameras = len(all_cameras) if all_cameras else 7
        total_zones = len(zones) if zones else 4
        
        start_dt = datetime.strptime(start_date, "%Y-%m-%d")
        end_dt = datetime.strptime(end_date, "%Y-%m-%d")
        days = []
        current = start_dt
        while current <= end_dt:
            days.append(current.strftime("%Y-%m-%d"))
            current += timedelta(days=1)
        
        daily_statistics = []
        zone_analysis = []
        camera_analysis = []
        
        for day in days:
            daily_summary = self.get_daily_summary(day)
            hourly_breakdown = self.get_hourly_breakdown_for_date(day)
            
            peak_period = None
            if hourly_breakdown:
                peak_hour_data = max(hourly_breakdown, key=lambda x: x['avg_percentage'])
                peak_period = {
                    'start_time': f"{day} {peak_hour_data['hour']:02d}:00",
                    'end_time': f"{day} {peak_hour_data['hour']+1:02d}:00",
                    'avg_percentage': peak_hour_data['avg_percentage'],
                    'total_people': peak_hour_data['total_people']
                }
            
            daily_statistics.append({
                'date': day,
                'total_measurements': daily_summary['total_measurements'],
                'hourly_breakdown': hourly_breakdown,
                'peak_periods': [peak_period] if peak_period else [],
                'summary': daily_summary
            })
        
        for zone in zones:
            if report_type == "daily":
                zone_data = self.get_zone_daily_analysis(zone, start_date)
            else:
                zone_data = self.get_zone_daily_analysis(zone, start_date)
                if zone_data:
                    zone_data['date_range'] = {'start_date': start_date, 'end_date': end_date}
            if zone_data:
                zone_analysis.append(zone_data)
        
        for camera_id in sorted(all_cameras):
            if report_type == "daily":
                cam_stats = self.get_camera_daily_stats(camera_id, start_date)
            else:
                cam_stats = self.get_camera_daily_stats(camera_id, start_date)
                if cam_stats:
                    cam_stats['date_range'] = {'start_date': start_date, 'end_date': end_date}
            if cam_stats:
                camera_name = camera_names.get(str(camera_id), f"Camera {camera_id}") if camera_names else f"Camera {camera_id}"
                cam_stats['camera_name'] = camera_name
                camera_analysis.append(cam_stats)
        
        first_day_summary = daily_statistics[0]['summary'] if daily_statistics else {}
        peak_hour_data = None
        if daily_statistics and daily_statistics[0]['hourly_breakdown']:
            peak_hour = max(daily_statistics[0]['hourly_breakdown'], key=lambda x: x['avg_percentage'])
            peak_hour_data = {
                'hour': peak_hour['hour'],
                'time': peak_hour['hour_label'],
                'avg_people': peak_hour['avg_people'],
                'avg_percentage': peak_hour['avg_percentage'],
                'max_people': peak_hour['max_people']
            }
        
        most_crowded_zone = None
        least_crowded_zone = None
        if zone_analysis:
            sorted_zones = sorted(zone_analysis, key=lambda x: x['avg_percentage'], reverse=True)
            most_crowded_zone = {
                'zone_name': sorted_zones[0]['zone_name'],
                'avg_percentage': sorted_zones[0]['avg_percentage'],
                'peak_hour': sorted_zones[0]['peak_hours'][0]['hour'] if sorted_zones[0]['peak_hours'] else None
            }
            least_crowded_zone = {
                'zone_name': sorted_zones[-1]['zone_name'],
                'avg_percentage': sorted_zones[-1]['avg_percentage'],
                'peak_hour': sorted_zones[-1]['peak_hours'][0]['hour'] if sorted_zones[-1]['peak_hours'] else None
            }
        
        executive_summary = {
            'total_people_today': first_day_summary.get('total_people', 0),
            'peak_hour': peak_hour_data,
            'total_capacity': first_day_summary.get('total_capacity', 0),
            'overall_occupancy_percentage': first_day_summary.get('overall_occupancy_percentage', 0),
            'most_crowded_zone': most_crowded_zone,
            'least_crowded_zone': least_crowded_zone
        }
        
        comparative_analysis = None
        if report_type == "multi_day":
            day_comparison = []
            for day_stat in daily_statistics:
                day_comparison.append({
                    'date': day_stat['date'],
                    'total_people': day_stat['summary']['total_people'],
                    'avg_percentage': day_stat['summary']['avg_percentage'],
                    'peak_hour': day_stat['hourly_breakdown'][0]['hour'] if day_stat['hourly_breakdown'] else None
                })
            
            if len(day_comparison) > 1:
                people_trend = "increasing" if day_comparison[-1]['total_people'] > day_comparison[0]['total_people'] else "decreasing" if day_comparison[-1]['total_people'] < day_comparison[0]['total_people'] else "stable"
                occupancy_trend = "increasing" if day_comparison[-1]['avg_percentage'] > day_comparison[0]['avg_percentage'] else "decreasing" if day_comparison[-1]['avg_percentage'] < day_comparison[0]['avg_percentage'] else "stable"
                
                peak_hours = [d['peak_hour'] for d in day_comparison if d['peak_hour']]
                peak_hour_stability = "consistent" if len(set(peak_hours)) <= 2 else "variable"
                
                comparative_analysis = {
                    'day_comparison': day_comparison,
                    'trends': {
                        'people_trend': people_trend,
                        'occupancy_trend': occupancy_trend,
                        'peak_hour_stability': peak_hour_stability
                    }
                }
        
        insights = []
        if peak_hour_data:
            insights.append(f"Peak occupancy occurred at {peak_hour_data['time']} with {peak_hour_data['avg_percentage']:.1f}% average occupancy")
        if most_crowded_zone:
            insights.append(f"{most_crowded_zone['zone_name'].replace('_', ' ').title()} zone requires attention with {most_crowded_zone['avg_percentage']:.1f}% average occupancy")
        if least_crowded_zone:
            insights.append(f"{least_crowded_zone['zone_name'].replace('_', ' ').title()} shows lowest utilization at {least_crowded_zone['avg_percentage']:.1f}%")
        if report_type == "multi_day" and comparative_analysis:
            if comparative_analysis['trends']['occupancy_trend'] == "increasing":
                insights.append("Occupancy trend shows increasing pattern - consider capacity planning")
            elif comparative_analysis['trends']['occupancy_trend'] == "decreasing":
                insights.append("Occupancy trend shows decreasing pattern")
        
        total_measurements = sum(d['total_measurements'] for d in daily_statistics)
        expected_measurements = len(days) * total_cameras * 14
        data_completeness = (total_measurements / expected_measurements * 100) if expected_measurements > 0 else 0
        
        report_data = {
            'report_metadata': {
                'report_id': report_id,
                'report_type': report_type,
                'generated_at': generated_at,
                'date_range': {
                    'start_date': start_date,
                    'end_date': end_date
                },
                'total_cameras': total_cameras,
                'total_zones': total_zones
            },
            'executive_summary': executive_summary,
            'daily_statistics': daily_statistics,
            'zone_analysis': zone_analysis,
            'camera_analysis': camera_analysis,
            'comparative_analysis': comparative_analysis,
            'insights_and_recommendations': insights,
            'data_quality': {
                'total_measurements': total_measurements,
                'expected_measurements': expected_measurements,
                'data_completeness': round(data_completeness, 2),
                'missing_hours': [],
                'anomalies_detected': 0
            }
        }
        
        return report_data
