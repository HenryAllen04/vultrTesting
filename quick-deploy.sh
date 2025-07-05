#!/bin/bash

# Purpose: Quick deployment script for leCommit hackathon app
# Builds, pushes, and provides deployment commands

set -e

echo "🚀 leCommit Hackathon - Quick Deployment"
echo "========================================"

# Step 1: Setup Docker registry
echo "🔧 Setting up Docker registry..."
./setup-docker-registry.sh

# Step 2: Build and push image
echo "🔨 Building and pushing image..."
./deploy.sh

echo ""
echo "✅ IMAGE DEPLOYED TO REGISTRY!"
echo ""
echo "🌐 NEXT: Deploy to Vultr Cloud Compute"
echo "========================================"
echo ""
echo "1️⃣ Create Vultr instance:"
echo "   - Go to https://my.vultr.com/deploy/"
echo "   - Choose: Cloud Compute"
echo "   - OS: Ubuntu 22.04 LTS"
echo "   - Plan: Regular Performance (25GB SSD - $6/month)"
echo "   - Location: Choose closest to your users"
echo "   - Click 'Deploy Now'"
echo ""
echo "2️⃣ Once instance is ready, SSH in:"
echo "   ssh root@YOUR_SERVER_IP"
echo ""
echo "3️⃣ Run this ONE-LINER on your server:"
echo "   curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && docker login lhr.vultrcr.com && docker run -d -p 80:3000 --name lecommit-app --restart unless-stopped lhr.vultrcr.com/lecommit1/lecommit-webapp:latest"
echo ""
echo "4️⃣ Access your app:"
echo "   🌐 Web: http://YOUR_SERVER_IP"
echo "   📊 Health: http://YOUR_SERVER_IP/api/health"
echo ""
echo "🎉 HACKATHON READY!" 