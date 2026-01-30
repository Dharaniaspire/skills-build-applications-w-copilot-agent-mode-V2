#!/usr/bin/env python3
import json
import urllib.request
import urllib.error

url = "http://localhost:8000/api/activities/"

# Test GET request
print("=" * 50)
print("Testing GET /api/activities/")
print("=" * 50)
try:
    response = urllib.request.urlopen(url)
    data = json.loads(response.read().decode())
    print(f"Status: {response.status}")
    print(f"Response: {json.dumps(data, indent=2)}")
except Exception as e:
    print(f"Error: {e}")

print("\n" + "=" * 50)
print("Testing POST /api/activities/ (Create Activity)")
print("=" * 50)

# Create a new activity
try:
    activity_data = {
        "user": 1,
        "activity_type": "running",
        "duration_minutes": 30,
        "distance_km": 5.5,
        "calories_burned": 350,
        "description": "Morning run at the park"
    }
    
    req = urllib.request.Request(
        url,
        data=json.dumps(activity_data).encode('utf-8'),
        headers={'Content-Type': 'application/json'},
        method='POST'
    )
    response = urllib.request.urlopen(req)
    data = json.loads(response.read().decode())
    print(f"Status: {response.status}")
    print(f"Created Activity: {json.dumps(data, indent=2)}")
except Exception as e:
    print(f"Error: {e}")

print("\n" + "=" * 50)
print("Testing GET /api/activities/ (After Create)")
print("=" * 50)

try:
    response = urllib.request.urlopen(url)
    data = json.loads(response.read().decode())
    print(f"Status: {response.status}")
    print(f"All Activities: {json.dumps(data, indent=2)}")
except Exception as e:
    print(f"Error: {e}")
