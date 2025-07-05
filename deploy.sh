#!/bin/bash

# Purpose: Deployment script for leCommit hackathon app on Vultr
# Builds Docker image and pushes to Vultr Container Registry

set -e

# Configuration
REGISTRY="lhr.vultrcr.com"
REGISTRY_NAME="lecommit1"
IMAGE_NAME="lecommit-webapp"
TAG=${1:-latest}
FULL_IMAGE_NAME="${REGISTRY}/${REGISTRY_NAME}/${IMAGE_NAME}:${TAG}"

echo "🚀 Starting deployment process for leCommit Hackathon App"
echo "📦 Building image: ${FULL_IMAGE_NAME}"

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t ${IMAGE_NAME}:${TAG} .

# Tag the image for Vultr registry
echo "🏷️  Tagging image for Vultr registry..."
docker tag ${IMAGE_NAME}:${TAG} ${FULL_IMAGE_NAME}

# Push to Vultr Container Registry
echo "⬆️  Pushing image to Vultr Container Registry..."
docker push ${FULL_IMAGE_NAME}

echo "✅ Deployment completed successfully!"
echo "📝 Image pushed to: ${FULL_IMAGE_NAME}"
echo ""
echo "🌐 Next steps:"
echo "  1. Create a Vultr Cloud Compute instance"
echo "  2. SSH into the instance"
echo "  3. Install Docker on the instance"
echo "  4. Run: docker login ${REGISTRY}"
echo "  5. Run: docker run -d -p 80:3000 --name lecommit-app ${FULL_IMAGE_NAME}"
echo "  6. Access your app at http://YOUR_SERVER_IP"
echo ""
echo "📊 Health check endpoint: http://YOUR_SERVER_IP/api/health" 