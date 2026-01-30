# OctoFit Tracker API Test Commands

## Quick Start - Test the API

### 1. Verify Server is Running
The Django development server is running on:
- **Local**: `http://localhost:8000`
- **Codespace**: `https://$CODESPACE_NAME-8000.app.github.dev`

### 2. Test Endpoints with curl

#### List All Activities (GET)
```bash
curl -X GET http://localhost:8000/api/activities/ \
  -H "Accept: application/json"
```

**Expected Response** (empty initially):
```json
[]
```

#### Create a Running Activity (POST)
```bash
curl -X POST http://localhost:8000/api/activities/ \
  -H "Content-Type: application/json" \
  -d '{
    "user": 1,
    "activity_type": "running",
    "duration_minutes": 30,
    "distance_km": 5.5,
    "calories_burned": 350,
    "description": "Morning run at the park"
  }'
```

**Expected Response**:
```json
{
  "id": 1,
  "user": 1,
  "activity_type": "running",
  "duration_minutes": 30,
  "distance_km": 5.5,
  "calories_burned": 350,
  "description": "Morning run at the park",
  "created_at": "2026-01-30T10:30:00.123456Z",
  "updated_at": "2026-01-30T10:30:00.123456Z"
}
```

#### Create a Cycling Activity (POST)
```bash
curl -X POST http://localhost:8000/api/activities/ \
  -H "Content-Type: application/json" \
  -d '{
    "user": 1,
    "activity_type": "cycling",
    "duration_minutes": 45,
    "distance_km": 15.2,
    "calories_burned": 420,
    "description": "Evening bike ride"
  }'
```

#### Create a Swimming Activity (POST)
```bash
curl -X POST http://localhost:8000/api/activities/ \
  -H "Content-Type: application/json" \
  -d '{
    "user": 1,
    "activity_type": "swimming",
    "duration_minutes": 20,
    "distance_km": 0.8,
    "calories_burned": 280,
    "description": "Pool session"
  }'
```

#### List All Activities (GET) - After Creating
```bash
curl -X GET http://localhost:8000/api/activities/ \
  -H "Accept: application/json"
```

**Expected Response**:
```json
[
  {
    "id": 3,
    "user": 1,
    "activity_type": "swimming",
    "duration_minutes": 20,
    "distance_km": 0.8,
    "calories_burned": 280,
    "description": "Pool session",
    "created_at": "2026-01-30T10:35:00.123456Z",
    "updated_at": "2026-01-30T10:35:00.123456Z"
  },
  {
    "id": 2,
    "user": 1,
    "activity_type": "cycling",
    "duration_minutes": 45,
    "distance_km": 15.2,
    "calories_burned": 420,
    "description": "Evening bike ride",
    "created_at": "2026-01-30T10:32:00.123456Z",
    "updated_at": "2026-01-30T10:32:00.123456Z"
  },
  {
    "id": 1,
    "user": 1,
    "activity_type": "running",
    "duration_minutes": 30,
    "distance_km": 5.5,
    "calories_burned": 350,
    "description": "Morning run at the park",
    "created_at": "2026-01-30T10:30:00.123456Z",
    "updated_at": "2026-01-30T10:30:00.123456Z"
  }
]
```

#### Get Specific Activity (GET)
```bash
curl -X GET http://localhost:8000/api/activities/1/ \
  -H "Accept: application/json"
```

#### Update Activity (PUT)
```bash
curl -X PUT http://localhost:8000/api/activities/1/ \
  -H "Content-Type: application/json" \
  -d '{
    "user": 1,
    "activity_type": "running",
    "duration_minutes": 35,
    "distance_km": 6.0,
    "calories_burned": 380,
    "description": "Morning run at the park - extended"
  }'
```

#### Partial Update Activity (PATCH)
```bash
curl -X PATCH http://localhost:8000/api/activities/1/ \
  -H "Content-Type: application/json" \
  -d '{
    "duration_minutes": 40,
    "description": "Extended morning run"
  }'
```

#### Delete Activity (DELETE)
```bash
curl -X DELETE http://localhost:8000/api/activities/1/ \
  -H "Accept: application/json"
```

## Advanced Testing

### Using Python Script
```bash
python test_api.py
```

### Using the Browsable API
Open in browser:
```
http://localhost:8000/api/activities/
```

The browsable API interface allows you to:
- View JSON response
- Try POST/PUT/PATCH/DELETE operations with a form
- See request/response details

### Using Postman/Insomnia

**Base URL**: `http://localhost:8000`

**Endpoints**:
- `GET /api/activities/` - List all
- `POST /api/activities/` - Create
- `GET /api/activities/{id}/` - Retrieve
- `PUT /api/activities/{id}/` - Full update
- `PATCH /api/activities/{id}/` - Partial update
- `DELETE /api/activities/{id}/` - Delete

## Codespaces Testing

To test from Codespaces URL:

1. Export your CODESPACE_NAME:
```bash
export CODESPACE_NAME=your-codespace-name
```

2. Use the HTTPS URL:
```bash
curl -X GET https://${CODESPACE_NAME}-8000.app.github.dev/api/activities/ \
  -H "Accept: application/json"
```

## Activity Types Supported
- `running` - Running
- `cycling` - Cycling
- `swimming` - Swimming
- `weightlifting` - Weight Lifting
- `yoga` - Yoga
- `walking` - Walking

## Response Status Codes
- **200 OK** - GET request successful
- **201 Created** - POST request successful
- **204 No Content** - DELETE successful
- **400 Bad Request** - Invalid data
- **404 Not Found** - Resource not found

## Common Issues & Solutions

### CSRF Token Error
The API is configured to accept JSON requests. Make sure to use:
```
-H "Content-Type: application/json"
```

### User ID Error (Cannot find user with ID 1)
Create a superuser first:
```bash
python manage.py createsuperuser
```
Then use the correct user ID.

### CORS Issues
The backend is configured for CORS. If testing from a different domain, check `CORS_ALLOWED_ORIGINS` in settings.py.

### Connection Refused
Ensure the server is running:
```bash
python manage.py runserver 0.0.0.0:8000
```
