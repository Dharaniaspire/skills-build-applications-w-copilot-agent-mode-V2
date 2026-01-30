#!/bin/bash

# OctoFit Tracker API Test Script
# This script tests the Django REST API endpoints

echo "========================================"
echo "OctoFit Tracker API Test Suite"
echo "========================================"
echo ""

# Get the CODESPACE_NAME from environment
CODESPACE_NAME="${CODESPACE_NAME:-localhost}"
API_URL="http://${CODESPACE_NAME}:8000/api"

echo "API Base URL: $API_URL"
echo ""

# Test 1: GET all activities (should return empty list initially)
echo "Test 1: GET all activities"
echo "Command: curl http://localhost:8000/api/activities/"
curl -s http://localhost:8000/api/activities/ | python3 -m json.tool
echo ""
echo "---"
echo ""

# Test 2: Create a new activity
echo "Test 2: POST - Create a new activity"
echo "Command: curl -X POST http://localhost:8000/api/activities/ ..."
curl -s -X POST http://localhost:8000/api/activities/ \
  -H "Content-Type: application/json" \
  -d '{
    "user": 1,
    "activity_type": "running",
    "duration_minutes": 30,
    "distance_km": 5.5,
    "calories_burned": 350,
    "description": "Morning run at the park"
  }' | python3 -m json.tool
echo ""
echo "---"
echo ""

# Test 3: GET all activities again
echo "Test 3: GET all activities (should show the newly created activity)"
echo "Command: curl http://localhost:8000/api/activities/"
curl -s http://localhost:8000/api/activities/ | python3 -m json.tool
echo ""
echo "---"
echo ""

# Test 4: Create another activity
echo "Test 4: POST - Create another activity (cycling)"
curl -s -X POST http://localhost:8000/api/activities/ \
  -H "Content-Type: application/json" \
  -d '{
    "user": 1,
    "activity_type": "cycling",
    "duration_minutes": 45,
    "distance_km": 15.2,
    "calories_burned": 420,
    "description": "Evening bike ride"
  }' | python3 -m json.tool
echo ""
echo "---"
echo ""

# Test 5: GET all activities with formatted output
echo "Test 5: Final API Status - All Activities"
echo "Command: curl http://localhost:8000/api/activities/"
RESPONSE=$(curl -s http://localhost:8000/api/activities/)
echo "$RESPONSE" | python3 -m json.tool
echo ""

echo "========================================"
echo "API Testing Complete!"
echo "========================================"
