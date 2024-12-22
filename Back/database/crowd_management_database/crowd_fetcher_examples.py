from datetime import datetime, timedelta
from crowd_data_fetcher import CrowdDataFetcher

def run_examples():
    # Initialize the fetcher
    fetcher = CrowdDataFetcher()
    print("Running examples for CrowdDataFetcher...\n")

    # 1. Get all zones
    print("1. Getting all zones:")
    zones = fetcher.get_all_zones()
    print(f"Available zones: {zones}")
    print("\n" + "="*50 + "\n")

    # 2. Get software_labreas (assuming 'software_lab' exists)
    print("2. Getting areas for software_lab:")
    areas = fetcher.get_zone_areas("software_lab")
    print(f"Areas in software_lab: {areas}")
    print("\n" + "="*50 + "\n")

    # 3. Get current occupancy
    print("3. Getting current occupancy for all zones:")
    occupancy = fetcher.get_current_occupancy()
    print("Current occupancy:")
    for record in occupancy:
        print(f"Zone: {record['zone_name']}, Area: {record['area_name']}, "
              f"People: {record['number_of_people']}/{record['capacity']}")
    print("\n" + "="*50 + "\n")

   
    # 4. Get peak hours
    print("4. Getting peak hours for software_lab:")
    peak_hours = fetcher.get_peak_hours("software_lab", days=7)
    for hour_data in peak_hours:
        print(f"Hour {hour_data['hour']:02d}:00 - Avg people: {hour_data['avg_people']}, "
              f"Max people: {hour_data['max_people']}")
    print("\n" + "="*50 + "\n")

    # 5. Get occupancy summary
    print("5. Getting occupancy summary:")
    summary = fetcher.get_occupancy_summary()
    print(f"Total cameras: {summary['total_cameras']}")
    print(f"Total capacity: {summary['total_capacity']}")
    print(f"Total people: {summary['total_people']}")
    print(f"Average occupancy: {summary['avg_occupancy']}%")
    print("\n" + "="*50 + "\n")

    # 6. Get data by time range
    print("6. Getting data for specific time range:")
    start = "2024-12-12 13:00"
    end = "2024-12-12 14:00"
    time_range_data = fetcher.get_data_by_time_range(start, end)
    if time_range_data:
        print(f"Found {time_range_data['total_records']} records between {start} and {end}")
    print("\n" + "="*50 + "\n")

    # 7. Get latest by camera
    print("7. Getting latest data for camera 1:")
    camera_data = fetcher.get_latest_by_camera(1)
    if camera_data:
        print(f"Latest reading: {camera_data['number_of_people']} people at {camera_data['measured_at']}")
    print("\n" + "="*50 + "\n")

   
    # 8. Get zone stats
    print("8. Getting stats for software_lab:")
    stats = fetcher.get_zone_stats("software_lab", hours=24)
    if stats:
        print(f"Average people: {stats['avg_people']}")
        print(f"Maximum people: {stats['max_people']}")
        print(f"Average occupancy: {stats['avg_percentage']}%")
        print(f"Maximum occupancy: {stats['max_percentage']}%")
    print("\n" + "="*50 + "\n")

    # 9. Get hourly averages
    print("9. Getting hourly averages for software_lab today:")
    today = datetime.now()
    hourly_data = fetcher.get_hourly_averages("software_lab", today)
    for hour in hourly_data:
        print(f"Hour: {hour['hour']}, Average people: {hour['avg_people']}")
    print("\n" + "="*50 + "\n")

    # 10. Get measurement by ID
    print("10. Getting measurement with ID 1:")
    measurement = fetcher.get_measurement_by_id(1)
    if measurement:
        print(f"Measurement details: {measurement}")
    print("\n" + "="*50 + "\n")

if __name__ == "__main__":
    try:
        run_examples()
    except Exception as e:
        print(f"Error running examples: {str(e)}")