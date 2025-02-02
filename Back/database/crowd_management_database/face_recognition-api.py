from fastapi import FastAPI, HTTPException, Query, Path
from typing import Optional, List, Dict
import uvicorn
from pydantic import BaseModel
from datetime import datetime
from fastapi.middleware.cors import CORSMiddleware  # Add this import


# Import the FaceRecognitionFetcher class
from face_recognition_fetcher import FaceRecognitionFetcher

app = FastAPI(title="Face Recognition API")
# Add CORS middleware configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)
face_fetcher = FaceRecognitionFetcher()

# Response Models
class Recognition(BaseModel):
    zone: str
    camera_id: str
    person_name: str
    position: str
    status: str
    timestamp: datetime

class unknown_recognition(BaseModel):
    zone_name: str
    camera_id: int  # Changed from str to int
    gender: str
    age: int      # Changed from str to int
    timestamp: datetime

class StatusDistribution(BaseModel):
    status: str
    count: int
    unique_people: int

class PositionSummary(BaseModel):
    position: str
    count: int
    
class StatusStats(BaseModel):
    labels: List[str]
    values: List[float]
    absolute_values: List[int]

@app.get("/")
async def root():
    return {"message": "Face Recognition API is running"}

@app.get("/recognitions/latest/", response_model=List[Recognition])
async def get_latest_recognitions(zone: Optional[str] = None):
    try:
        return face_fetcher.get_latest_recognitions(zone)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recognitions/person/{person_name}", response_model=List[Recognition])
async def get_person_history(
    person_name: str,
    hours: int = Query(24, ge=1, description="Number of hours to look back")
):
    try:
        return face_fetcher.get_person_history(person_name, hours)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recognitions/status/distribution", response_model=List[StatusDistribution])
async def get_status_distribution(
    zone: Optional[str] = None,
    hours: int = Query(1, ge=1, description="Number of hours to look back")
):
    try:
        return face_fetcher.get_status_distribution(zone, hours)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recognitions/search/", response_model=List[Recognition])
async def search_person(
    query: str = Query(..., min_length=2, description="Search query for person name")
):
    try:
        return face_fetcher.search_person(query)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recognitions/positions/", response_model=List[PositionSummary])
async def get_position_summary(zone: Optional[str] = None):
    try:
        return face_fetcher.get_position_summary(zone)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/recognitions/all/", response_model=List[Recognition])
async def get_all_records(
    limit: Optional[int] = Query(None, ge=1, description="Maximum number of records to return"),
    offset: Optional[int] = Query(0, ge=0, description="Number of records to skip")
):
    try:
        return face_fetcher.get_all_records(limit, offset)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/status-stats/", response_model=StatusStats)
async def get_status_stats():
    """
    Get status distribution statistics for pie chart visualization
    Returns labels, percentage values, and absolute counts
    """
    try:
        return face_fetcher.get_status_stats()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



@app.get("/recognitions/last/{n}", response_model=List[Recognition])
async def get_last_n_records(
    n: int = Path(..., gt=0, description="Number of last records to return")
):
    """
    Get the last N face recognition records
    """
    try:
        return face_fetcher.get_last_n_records(n)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
@app.get("/recognitions/unknown/last/{n}", response_model=List[unknown_recognition])
async def get_last_n_records_unknown(
    n: int = Path(..., gt=0, description="Number of last records to return")
):
    """
    Get the last N unknown face recognition records
    """
    try:
        return face_fetcher.get_last_n_records_unknown(n)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    
    
    
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8020)