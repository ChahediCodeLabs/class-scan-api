# ClassScan Flask API

This Flask API handles face recognition processing for the ClassScan application.

## Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Firebase service account key

## Setup Instructions

### 1. Install Dependencies

```bash
cd flask-api
pip install -r requirements.txt
```

### 2. Get Firebase Service Account Key

1. Go to Firebase Console: https://console.firebase.google.com/
2. Select your project (classscan-4fc7a)
3. Go to Project Settings (gear icon) → Service Accounts
4. Click "Generate New Private Key"
5. Save the downloaded JSON file as `serviceAccountKey.json` in the `flask-api` folder

### 3. Run Locally

```bash
python app.py
```

The API will run on `http://localhost:5000`

## API Endpoints

### Health Check
```
GET /health
```

### Encode Student Face
```
POST /encode-student
Content-Type: application/json

{
  "imageUrl": "https://firebase-storage-url..."
}

Response:
{
  "success": true,
  "encodings": [array of floats]
}
```

### Process Attendance
```
POST /process-attendance
Content-Type: application/json

{
  "classImageUrl": "https://firebase-storage-url...",
  "students": [
    {
      "id": "student-id",
      "name": "Student Name",
      "encodings": [array of floats]
    }
  ]
}

Response:
{
  "success": true,
  "results": [
    {
      "id": "student-id",
      "name": "Student Name",
      "isAbsent": false
    }
  ]
}
```

## Deployment Options

### Option 1: Railway.app (Recommended - Easy & Free Tier)

1. Create account at https://railway.app/
2. Create new project → Deploy from GitHub
3. Add environment variables if needed
4. Railway will auto-deploy from your repo
5. Get your deployment URL (e.g., `https://your-app.railway.app`)

### Option 2: Heroku

1. Install Heroku CLI
2. Create `Procfile` with content:
   ```
   web: gunicorn app:app
   ```
3. Deploy:
   ```bash
   heroku create your-app-name
   git push heroku main
   ```

### Option 3: Render.com

1. Create account at https://render.com/
2. New Web Service → Connect your GitHub repo
3. Build Command: `pip install -r requirements.txt`
4. Start Command: `gunicorn app:app`
5. Add environment variables if needed

### Option 4: Google Cloud Run

1. Install Google Cloud SDK
2. Build and deploy:
   ```bash
   gcloud run deploy classscan-api \
     --source . \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated
   ```

## Environment Variables

The API uses the following environment variables:

- `PORT`: Port to run the server (default: 5000)

## Integration with React Frontend

After deploying your API, update the React frontend to use your API URL:

1. Create a `.env` file in your React project root (not in git):
   ```
   VITE_FLASK_API_URL=https://your-deployed-api-url.com
   ```

2. Update the React code to call your API:
   ```typescript
   const API_URL = import.meta.env.VITE_FLASK_API_URL || 'http://localhost:5000';
   
   // When adding a student
   const response = await fetch(`${API_URL}/encode-student`, {
     method: 'POST',
     headers: { 'Content-Type': 'application/json' },
     body: JSON.stringify({ imageUrl })
   });
   
   // When processing attendance
   const response = await fetch(`${API_URL}/process-attendance`, {
     method: 'POST',
     headers: { 'Content-Type': 'application/json' },
     body: JSON.stringify({ classImageUrl, students })
   });
   ```

## Security Notes

- Never commit `serviceAccountKey.json` to git
- Add `serviceAccountKey.json` to `.gitignore`
- Use environment variables for sensitive data in production
- Enable CORS only for your React app domain in production

## Troubleshooting

### "No face detected in image"
- Ensure the image has a clear, visible face
- Try with better lighting or different angle
- The face should be frontal and not too small

### Memory issues on free tier
- Reduce image size before processing
- Use a higher tier with more RAM

### Slow processing
- Face recognition is CPU-intensive
- Consider using a faster server or GPU instance
- Implement caching for encodings
