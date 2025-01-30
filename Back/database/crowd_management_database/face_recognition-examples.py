# # /Back/database/crowd_management_database/face-recognition-examples.py
import logging
from db_connector import DatabaseConnector
from datetime import datetime, timedelta
from face_recognition_fetcher import FaceRecognitionFetcher
from pprint import pprint

def display_detailed_data():
    fetcher = FaceRecognitionFetcher()
    print("DETAILED DATA DUMP FROM FACE RECOGNITION DATABASE\n")

    zones = fetcher.get_all_zones()


    print("2. ALL RECORDS (Full Dataset)")
    print("-" * 50)
    all_records = fetcher.get_all_records()
    pprint(all_records)
    print(f"Total Records: {len(all_records)}\n")

    print("3. LATEST RECOGNITIONS (ALL ZONES)")
    print("-" * 50)
    latest = fetcher.get_latest_recognitions()
    pprint(latest)
    print("\n")

    print("5. PERSON HISTORY (Last 24 hours for each unique person)")
    print("-" * 50)
    unique_people = set(record['person_name'] for record in latest)
    for person in unique_people:
        print(f"\nHistory for {person}:")
        history = fetcher.get_person_history(person, hours=24)
        pprint(history)
    print("\n")

    print("7. STATUS DISTRIBUTION (Last hour)")
    print("-" * 50)
    all_status = fetcher.get_status_distribution(hours=1)
    pprint(all_status)
    print("\nBy Zone:")
    for zone in zones:
        print(f"\nZone: {zone}")
        zone_status = fetcher.get_status_distribution(zone=zone, hours=1)
        pprint(zone_status)
    print("\n")

    print("9. POSITION SUMMARY")
    print("-" * 50)
    print("\nOverall Position Summary:")
    positions = fetcher.get_position_summary()
    pprint(positions)
    print("\nBy Zone:")
    for zone in zones:
        print(f"\nZone: {zone}")
        zone_positions = fetcher.get_position_summary(zone=zone)
        pprint(zone_positions)
    print("\n")

    print("10. PAGINATED RECORDS EXAMPLE")
    print("-" * 50)
    print("\nFirst 10 records:")
    first_page = fetcher.get_all_records(limit=10)
    pprint(first_page)
    print("\nNext 10 records:")
    next_page = fetcher.get_all_records(limit=10, offset=10)
    pprint(next_page)

if __name__ == "__main__":
    try:
        display_detailed_data()
    except Exception as e:
        print(f"Error displaying detailed data: {str(e)}")