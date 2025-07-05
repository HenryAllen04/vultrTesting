#!/bin/bash

# Purpose: Automated deployment script using Vultr API
# Creates cloud compute instance and deploys the application

set -e

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Check if API key is set
if [ -z "$VULTR_API_KEY" ]; then
    echo "❌ Error: VULTR_API_KEY not found in .env file"
    echo "Please add your Vultr API key to .env file:"
    echo "VULTR_API_KEY=your_api_key_here"
    exit 1
fi

echo "🤖 leCommit Hackathon - Automated Deployment"
echo "============================================"

# Step 1: Build and push image
echo "🔧 Setting up Docker registry..."
./setup-docker-registry.sh

echo "🔨 Building and pushing image..."
./deploy.sh

# Step 2: Create Vultr instance using API
echo "☁️  Creating Vultr Cloud Compute instance..."

# Configuration
REGION="lhr"  # London - change as needed
PLAN="vc2-1c-1gb"  # $6/month plan
OS_ID="387"  # Ubuntu 22.04 LTS
LABEL="lecommit-hackathon-$(date +%s)"

# Create instance
INSTANCE_RESPONSE=$(curl -s -X POST "https://api.vultr.com/v2/instances" \
  -H "Authorization: Bearer $VULTR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "region": "'$REGION'",
    "plan": "'$PLAN'",
    "os_id": '$OS_ID',
    "label": "'$LABEL'",
    "hostname": "lecommit-hackathon",
    "enable_ipv6": false,
    "enable_private_network": false,
    "auto_backups": false,
    "ddos_protection": false,
    "activation_email": false
  }')

# Extract instance ID
INSTANCE_ID=$(echo $INSTANCE_RESPONSE | grep -o '"id":"[^"]*' | sed 's/"id":"//')

if [ -z "$INSTANCE_ID" ]; then
    echo "❌ Failed to create instance. Response:"
    echo "$INSTANCE_RESPONSE"
    exit 1
fi

echo "✅ Instance created! ID: $INSTANCE_ID"
echo "⏳ Waiting for instance to be ready..."

# Wait for instance to be ready
MAX_WAIT=300  # 5 minutes
WAIT_COUNT=0

while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
    STATUS_RESPONSE=$(curl -s -X GET "https://api.vultr.com/v2/instances/$INSTANCE_ID" \
      -H "Authorization: Bearer $VULTR_API_KEY")
    
    STATUS=$(echo $STATUS_RESPONSE | grep -o '"status":"[^"]*' | sed 's/"status":"//')
    
    if [ "$STATUS" = "active" ]; then
        break
    fi
    
    echo "⏳ Instance status: $STATUS (waiting...)"
    sleep 10
    WAIT_COUNT=$((WAIT_COUNT + 10))
done

if [ "$STATUS" != "active" ]; then
    echo "❌ Instance failed to become active within 5 minutes"
    exit 1
fi

# Get instance IP
IP_ADDRESS=$(echo $STATUS_RESPONSE | grep -o '"main_ip":"[^"]*' | sed 's/"main_ip":"//')

echo "🌐 Instance ready! IP: $IP_ADDRESS"
echo "📝 Instance details saved to: instance-info.txt"

# Save instance info
cat > instance-info.txt << EOF
Instance ID: $INSTANCE_ID
IP Address: $IP_ADDRESS
Label: $LABEL
Status: $STATUS
Created: $(date)
EOF

echo ""
echo "🚀 DEPLOYMENT COMPLETE!"
echo "======================"
echo "🌐 Your app will be available at: http://$IP_ADDRESS"
echo "📊 Health check: http://$IP_ADDRESS/api/health"
echo ""
echo "⏳ Note: It may take 2-3 minutes for the server to fully boot and install Docker"
echo "📝 SSH access: ssh root@$IP_ADDRESS"
echo ""
echo "🎉 HACKATHON READY!"

# Step 3: Create deployment script for the server
cat > server-setup.sh << 'EOF'
#!/bin/bash
# Server setup script - run this on your Vultr instance

echo "🔧 Setting up Docker and deploying app..."

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Start Docker service
systemctl start docker
systemctl enable docker

# Login to Vultr Container Registry
docker login lhr.vultrcr.com

# Run the application
docker run -d \
  -p 80:3000 \
  --name lecommit-app \
  --restart unless-stopped \
  lhr.vultrcr.com/lecommit-webapp:latest

echo "✅ Deployment complete!"
echo "🌐 App available at: http://$(curl -s ifconfig.me)"
EOF

chmod +x server-setup.sh

echo "💡 To complete deployment, SSH into your server and run:"
echo "   scp server-setup.sh root@$IP_ADDRESS:~/"
echo "   ssh root@$IP_ADDRESS 'bash server-setup.sh'" 