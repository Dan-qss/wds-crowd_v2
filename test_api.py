import requests

BASE_URL = "http://127.0.0.1:8010/analysis/zone-occupancy"

# CHANGE THESE TO A TIME RANGE YOU KNOW HAS DATA
start_time = "2025-12-11 14:00"
end_time   = "2025-12-11 14:15"

params = {
    "start_time": start_time,
    "end_time": end_time
}

print("➡ Sending request...")
print("URL:", BASE_URL)
print("Params:", params)

try:
    resp = requests.get(BASE_URL, params=params)
    print("\nStatus Code:", resp.status_code)
    print("Raw Response Text:", resp.text)

    # Try JSON decode
    try:
        data = resp.json()
        print("\nJSON Parsed Response:\n", data)
    except Exception as e:
        print("\n⚠ JSON parse failed:", e)

except Exception as e:
    print("\n❌ Request failed:", e)
