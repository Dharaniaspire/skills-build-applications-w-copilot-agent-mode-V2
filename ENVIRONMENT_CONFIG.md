# OctoFit Tracker - Environment Configuration

## CODESPACE_NAME Environment Variable

### What is CODESPACE_NAME?
`CODESPACE_NAME` is an environment variable automatically set by GitHub Codespaces that contains the unique name of your codespace.

### Format
```
{adjective}-{animal}-{identifier}
```
Example: `melodic-potato-x6p6wxrx`

### How It's Used in OctoFit Tracker

#### 1. In Django Settings (settings.py)
```python
ALLOWED_HOSTS = [
    'localhost',
    '127.0.0.1',
    os.getenv('CODESPACE_NAME', 'localhost') + '-8000.app.github.dev' if os.getenv('CODESPACE_NAME') else 'localhost',
]
```

This dynamically adds your Codespace hostname to allowed hosts:
- Local development: `localhost:8000`
- Codespace: `{CODESPACE_NAME}-8000.app.github.dev`

#### 2. CORS Configuration (settings.py)
```python
CORS_ALLOWED_ORIGINS = [
    'http://localhost',
    'http://localhost:3000',
    'http://127.0.0.1',
    'http://127.0.0.1:3000',
]

if os.getenv('CODESPACE_NAME'):
    CORS_ALLOWED_ORIGINS.append(f"https://{os.getenv('CODESPACE_NAME')}-8000.app.github.dev")
    CORS_ALLOWED_ORIGINS.append(f"https://{os.getenv('CODESPACE_NAME')}-3000.app.github.dev")
```

This allows both HTTP (localhost) and HTTPS (Codespace) requests.

## API Endpoint Format

### Local Testing
```
http://localhost:8000/api/activities/
```

### Codespace Testing
```
https://{CODESPACE_NAME}-8000.app.github.dev/api/activities/
```

Example (if CODESPACE_NAME = "melodic-potato-x6p6wxrx"):
```
https://melodic-potato-x6p6wxrx-8000.app.github.dev/api/activities/
```

## Port Configuration

### Forwarded Ports (as per requirements)
- **8000**: Django Backend (public)
  - Local: `http://localhost:8000`
  - Codespace: `https://{CODESPACE_NAME}-8000.app.github.dev`

- **3000**: React Frontend (public)
  - Local: `http://localhost:3000`
  - Codespace: `https://{CODESPACE_NAME}-3000.app.github.dev`

- **27017**: MongoDB (private)
  - Only accessible within the codespace environment

## Why Use Environment Variables?

### Benefits
1. **No Hardcoding**: Avoid hardcoding Codespace names in code
2. **Development & Production**: Same code works in:
   - Local development (`localhost:8000`)
   - GitHub Codespaces (HTTPS URL)
   - Production servers

3. **Security**: Automatically handles HTTPS/HTTP based on environment
4. **Flexibility**: Easy to switch environments without code changes

## Testing with CODESPACE_NAME

### Step 1: Verify the Environment Variable
```bash
echo $CODESPACE_NAME
```

### Step 2: Test API with Codespace URL
```bash
curl -X GET "https://${CODESPACE_NAME}-8000.app.github.dev/api/activities/" \
  -H "Accept: application/json"
```

### Step 3: Accessing from Frontend
If your React frontend is in the same Codespace:
```javascript
// In React component
const API_BASE = process.env.REACT_APP_CODESPACE_NAME 
  ? `https://${process.env.REACT_APP_CODESPACE_NAME}-8000.app.github.dev/api`
  : 'http://localhost:8000/api';

// Usage
fetch(`${API_BASE}/activities/`)
```

## Environment Variable Not Set?

If you're testing locally without Codespaces:
```bash
# The settings will use 'localhost' as the default
# No action needed - Django will work on localhost:8000
```

## Troubleshooting

### HTTPS Certificate Issues
- **Why**: Codespaces provides self-signed certificates
- **Solution**: Django automatically trusts the Codespace domain
- **For Curl**: Add `-k` flag to insecure connections (dev only)
  ```bash
  curl -k "https://${CODESPACE_NAME}-8000.app.github.dev/api/activities/"
  ```

### Codespace URL Not Accessible
1. Verify port 8000 is forwarded
2. Check `$CODESPACE_NAME` is set
3. Confirm Django is running
4. Check ALLOWED_HOSTS includes your Codespace name

### Mixed Content Warning
- Don't mix HTTP and HTTPS in frontend/backend calls
- Use HTTPS for Codespace URLs
- Use HTTP for localhost

## Reference

### Django Settings Configuration
- **File**: `octofit-tracker/backend/octofit_tracker/settings.py`
- **Lines**: ALLOWED_HOSTS, CORS_ALLOWED_ORIGINS
- **Environment Variable**: `os.getenv('CODESPACE_NAME')`

### React Configuration
- **File**: `.vscode/launch.json`
- **Environment**: `REACT_APP_CODESPACE_NAME`
- **Usage**: Frontend can read via `process.env.REACT_APP_CODESPACE_NAME`

### Port Forwarding
- **Settings**: GitHub Codespaces port forwarding
- **Visibility**: 8000 and 3000 are public
- **Security**: 27017 (MongoDB) is private
