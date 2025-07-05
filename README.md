# leCommit Hackathon Web App 🚀

A Node.js web application containerized with Docker and ready for deployment on Vultr Cloud.

## Features

- **Express.js API** with health checks and data endpoints
- **Modern Frontend** with interactive API testing
- **Docker Containerization** with multi-stage builds
- **Production Ready** with security best practices
- **Vultr Container Registry** integration

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Welcome message and app info |
| GET | `/api/health` | Health check endpoint |
| GET | `/api/info` | Application information |
| POST | `/api/data` | Submit data to the API |

## Quick Start

### Prerequisites

- Docker installed on your machine
- Vultr account with Container Registry access
- Node.js 18+ (for local development)

### Local Development

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Run locally:**
   ```bash
   npm start
   ```

3. **Run in development mode:**
   ```bash
   npm run dev
   ```

### Docker Development

1. **Build and run with Docker Compose:**
   ```bash
   docker-compose up --build
   ```

2. **Access the app:**
   - Web interface: http://localhost:3000
   - API health check: http://localhost:3000/api/health

## Deployment on Vultr

### Step 1: Setup Vultr Container Registry

1. Create a Container Registry on Vultr
2. Save your registry credentials (you should have these already)

### Step 2: Configure Docker Login

Create a `~/.docker/config.json` file with your Vultr registry credentials:

```json
{
  "auths": {
    "lhr.vultrcr.com": {
      "auth": "YOUR_BASE64_ENCODED_CREDENTIALS"
    }
  }
}
```

### Step 3: Build and Push Image

1. **Make the deploy script executable:**
   ```bash
   chmod +x deploy.sh
   ```

2. **Run the deployment script:**
   ```bash
   ./deploy.sh
   ```

   Or with a specific tag:
   ```bash
   ./deploy.sh v1.0.0
   ```

### Step 4: Deploy on Vultr Cloud Compute

1. **Create a Vultr Cloud Compute instance**
   - Choose Ubuntu 22.04 LTS
   - Select appropriate size (Regular Performance, $6/month minimum)
   - Enable IPv4

2. **SSH into your instance:**
   ```bash
   ssh root@YOUR_SERVER_IP
   ```

3. **Install Docker:**
   ```bash
   apt update
   apt install -y docker.io
   systemctl start docker
   systemctl enable docker
   ```

4. **Login to Vultr Container Registry:**
   ```bash
   docker login lhr.vultrcr.com
   ```

5. **Run your application:**
   ```bash
   docker run -d \
     -p 80:3000 \
     --name lecommit-app \
     --restart unless-stopped \
     lhr.vultrcr.com/lecommit-webapp:latest
   ```

6. **Access your app:**
   - Web interface: http://YOUR_SERVER_IP
   - API health check: http://YOUR_SERVER_IP/api/health

## Required Credentials for Deployment

You'll need:

1. **Vultr Container Registry credentials** ✅ (you have these)
2. **Vultr API Key** (for programmatic cloud resource management)
   - Go to Account → API → Generate API Key
   - Used for creating/managing cloud instances via API

## Monitoring and Logs

- **View container logs:**
  ```bash
  docker logs lecommit-app
  ```

- **View container status:**
  ```bash
  docker ps
  ```

- **Health check:**
  ```bash
  curl http://localhost/api/health
  ```

## Security Features

- Non-root user in Docker container
- Helmet.js for security headers
- CORS enabled
- Input validation
- Health checks
- Graceful shutdown handling

## Troubleshooting

### Common Issues

1. **Port already in use:**
   ```bash
   docker stop lecommit-app
   docker rm lecommit-app
   ```

2. **Image not found:**
   - Ensure you're logged into the registry
   - Check image name and tag

3. **Container not starting:**
   - Check logs: `docker logs lecommit-app`
   - Verify port availability

### Development Tips

- Use `docker-compose up --build` for development
- Check `docker-compose logs` for debugging
- Use `docker exec -it lecommit-webapp sh` to access container

## Project Structure

```
leCommit/
├── server.js              # Main application server
├── package.json           # Node.js dependencies
├── Dockerfile             # Container configuration
├── docker-compose.yml     # Local development setup
├── .dockerignore          # Docker build exclusions
├── deploy.sh              # Deployment script
├── public/
│   └── index.html         # Frontend interface
└── README.md              # This file
```

## License

MIT License - feel free to use this for your hackathon! 🎉 