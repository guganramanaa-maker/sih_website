# Docker Deployment Guide for AICTE Web Portal

This project is packaged with a production-ready, lightweight Docker configuration based on **Nginx on Alpine Linux** (approx. 25MB total image size).

---

## 1. Quick Local Testing with Docker

Make sure Docker Desktop is running on your machine, then run:

### Using Docker CLI:
```bash
# 1. Build the Docker image
docker build -t aicte-portal:latest .

# 2. Run the container
docker run -d -p 8080:80 --name aicte_portal aicte-portal:latest
```
Open your browser and visit: **`http://localhost:8080`**

### Or Using Docker Compose:
```bash
docker compose up -d
```
To stop the container:
```bash
docker compose down
```

---

## 2. Uploading to Docker Hub (Public / Private Registry)

To share the container or host it on any cloud server:

```bash
# 1. Login to Docker Hub
docker login

# 2. Tag your image with your Docker Hub username
docker tag aicte-portal:latest <your-dockerhub-username>/aicte-portal:latest

# 3. Push to Docker Hub
docker push <your-dockerhub-username>/aicte-portal:latest
```

---

## 3. Deploying to the Internet (Free & Easy Cloud Options)

### Option A: Render.com (Recommended - Free & Instant)
1. Push this folder to a GitHub repository.
2. Go to [render.com](https://render.com) and click **New +** -> **Web Service**.
3. Connect your GitHub repository.
4. Render will automatically detect the **`Dockerfile`**.
5. Click **Create Web Service** — Render will build and deploy your website live with a free HTTPS URL (e.g. `https://aicte-portal.onrender.com`).

### Option B: Railway.app
1. Go to [railway.app](https://railway.app).
2. Click **New Project** -> **Deploy from GitHub repo** (or use the Railway CLI: `railway up`).
3. Railway builds the `Dockerfile` and gives you a public domain.

### Option C: Google Cloud Run (Serverless Container)
```bash
# Submit and deploy directly to Cloud Run
gcloud run deploy aicte-portal --source . --platform managed --allow-unauthenticated --region asia-south1
```

### Option D: Any VPS / Linux Server (DigitalOcean, AWS EC2, Linode)
SSH into your server and run:
```bash
# Run on standard HTTP port 80
docker run -d --restart always -p 80:80 <your-dockerhub-username>/aicte-portal:latest
```

---

## 4. Configuration Details

- **Web Server**: `nginx:alpine`
- **Port**: Container listens on port `80`
- **Compression**: Gzip compression is pre-configured in `nginx.conf` for CSS, JS, HTML, JSON, and SVG.
- **MIME Types**: Full support including `.avif`, `.pdf`, `.png`, `.jpg`, and modern fonts.
- **Security Headers**: Includes `X-Frame-Options`, `X-Content-Type-Options`, and `Referrer-Policy`.

