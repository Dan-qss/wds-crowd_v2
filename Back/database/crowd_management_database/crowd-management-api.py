from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, timedelta
from typing import List, Optional, Dict
from pydantic import BaseModel, Field
import uvicorn
from crowd_data_fetcher import CrowdDataFetcher

app = FastAPI(
    title="Crowd Management API",
    description="API for managing and retrieving crowd measurements data",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Initialize the CrowdDataFetcher
crowd_fetcher = CrowdDataFetcher()

# Pydantic models for response data
class MeasurementBase(BaseModel):
    measurement_id: int
    camera_id: int
    zone_name: str
    area_name: str
    capacity: int
    number_of_people: int
    crowding_level: str
    crowding_percentage: float
    measured_at: datetime


class SimpleMeasurement(BaseModel):
    camera_id: int
    zone_name: str
    number_of_people: int
    crowding_level: str
    crowding_percentage: float

class ZoneChartData(BaseModel):
    labels: List[str]
    values: List[float]
    absolute_values: List[float]

class ZoneOccupancyResponse(BaseModel):
    time_range: Dict[str, str]
    total_zones: int
    total_cameras: int
    zone_data: List[Dict]
    camera_data: List[Dict]
    chart_data: ZoneChartData



class TimeRangeResponse(BaseModel):
    total_records: int
    time_range: dict
    data: List[SimpleMeasurement]

class ZoneStats(BaseModel):
    avg_people: float
    max_people: float
    avg_percentage: float
    max_percentage: float

class OccupancySummary(BaseModel):
    total_cameras: int
    total_capacity: int
    total_people: int
    avg_occupancy: float

class HourlyAverage(BaseModel):
    hour: datetime
    avg_people: float
    avg_percentage: float

class PeakHourData(BaseModel):
    hour: int
    avg_people: float
    avg_percentage: float
    max_people: int
    max_percentage: float

@app.get("/")
async def root():
    return {"message": "Welcome to Crowd Management API"}

@app.get("/zones", response_model=List[str])
async def get_zones():
    """Get all available zones"""
    return crowd_fetcher.get_all_zones()

@app.get("/zones/{zone_name}/areas", response_model=List[str])
async def get_zone_areas(zone_name: str):
    """Get all areas in a specific zone"""
    areas = crowd_fetcher.get_zone_areas(zone_name)
    if not areas:
        raise HTTPException(status_code=404, detail="Zone not found")
    return areas

@app.get("/occupancy/current", response_model=List[MeasurementBase])
async def get_current_occupancy(zone_name: Optional[str] = None):
    """Get current occupancy data"""
    return crowd_fetcher.get_current_occupancy(zone_name)

@app.get("/occupancy/summary", response_model=OccupancySummary)
async def get_occupancy_summary(zone_name: Optional[str] = None):
    """Get occupancy summary statistics"""
    return crowd_fetcher.get_occupancy_summary(zone_name)

@app.get("/measurements/timerange", response_model=TimeRangeResponse)
async def get_data_by_time_range(
    start_time: str = Query(..., description="Start time (YYYY-MM-DD HH:MM)"),
    end_time: str = Query(..., description="End time (YYYY-MM-DD HH:MM)")
):
    """Get measurements within a specific time range"""
    try:
        data = crowd_fetcher.get_data_by_time_range(start_time, end_time)
        if not data:
            raise HTTPException(status_code=404, detail="No data found for the specified time range")
        
        # Add logging to debug the response
        print("Response data:", data)  # For debugging
        
        return data
    except Exception as e:
        print(f"Error in endpoint: {str(e)}")  # For debugging
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/measurements/{measurement_id}", response_model=MeasurementBase)
async def get_measurement(measurement_id: int):
    """Get a specific measurement by ID"""
    data = crowd_fetcher.get_measurement_by_id(measurement_id)
    if not data:
        raise HTTPException(status_code=404, detail="Measurement not found")
    return data

@app.get("/analysis/zone-occupancy", response_model=ZoneOccupancyResponse)
async def get_zone_occupancy_percentages(
    start_time: str = Query(..., description="Start time (YYYY-MM-DD HH:MM)"),
    end_time: str = Query(..., description="End time (YYYY-MM-DD HH:MM)")
):
    """Get occupancy percentages aggregated by zones"""
    try:
        data = crowd_fetcher.get_occupancy_percentages_by_zone(start_time, end_time)
        if not data:
            raise HTTPException(status_code=404, detail="No data found for the specified time range")
        return data
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

async def get_latest_by_camera(camera_id: int):
    """Get latest measurement for a specific camera"""
    data = crowd_fetcher.get_latest_by_camera(camera_id)
    if not data:
        raise HTTPException(status_code=404, detail="Camera not found or no data available")
    return data

@app.get("/zones/{zone_name}/stats", response_model=ZoneStats)
async def get_zone_stats(
    zone_name: str,
    hours: int = Query(24, description="Number of hours to analyze")
):
    """Get statistics for a specific zone"""
    stats = crowd_fetcher.get_zone_stats(zone_name, hours)
    if not stats:
        raise HTTPException(status_code=404, detail="Zone not found or no data available")
    return stats

@app.get("/zones/{zone_name}/peak-hours", response_model=List[PeakHourData])
async def get_peak_hours(
    zone_name: str,
    days: int = Query(7, description="Number of days to analyze")
):
    """Get peak hours analysis for a zone"""
    data = crowd_fetcher.get_peak_hours(zone_name, days)
    if not data:
        raise HTTPException(status_code=404, detail="Zone not found or no data available")
    return data

@app.get("/zones/{zone_name}/hourly-averages", response_model=List[HourlyAverage])
async def get_hourly_averages(
    zone_name: str,
    date: datetime = Query(None, description="Date to analyze (defaults to today)")
):
    """Get hourly averages for a specific date"""
    if date is None:
        date = datetime.now()
    data = crowd_fetcher.get_hourly_averages(zone_name, date)
    if not data:
        raise HTTPException(status_code=404, detail="Zone not found or no data available")
    return data

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8050)
    
    
    # for testing the api 
    # 1- http://127.0.0.1:8050/zones
    # 2- http://127.0.0.1:8050/zones/software_lab/areas
    # 3- http://127.0.0.1:8050/occupancy/current
    # 4- http://127.0.0.1:8050/occupancy/summary
    # 5- http://127.0.0.1:8050/measurements/timerange?start_time=2024-12-12 13:00&end_time=2024-12-12 14:00
    # 6- http://127.0.0.1:8050/measurements/7
    # 7- http://127.0.0.1:8050/camera/1/latest
    # 8- http://127.0.0.1:8050/zones/showroom/stats
    # 9- http://127.0.0.1:8050/zones/showroom/peak-hours
    # 10- http://127.0.0.1:8050/software_lab/hourly-averages
    
    
    
    
    
