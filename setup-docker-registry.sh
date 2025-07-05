#!/bin/bash

# Purpose: Setup Docker registry login for Vultr Container Registry
# Configures Docker to authenticate with lhr.vultrcr.com

set -e

REGISTRY="lhr.vultrcr.com"
DOCKER_CONFIG_DIR="$HOME/.docker"
DOCKER_CONFIG_FILE="$DOCKER_CONFIG_DIR/config.json"

echo "🔧 Setting up Docker registry authentication for Vultr..."

# Create Docker config directory if it doesn't exist
mkdir -p "$DOCKER_CONFIG_DIR"

# Create or update Docker config with Vultr registry credentials
cat > "$DOCKER_CONFIG_FILE" << EOF
{
  "auths": {
    "$REGISTRY": {
      "auth": "cm9ib3QkbGVjb21taXQxKzczOThkYWNkLThiMTUtNGFiNi04YTAzLTk2YTY3ODBmZWNmODphd0Z0RkdBcVNCRGZLeVltUGNOM1FyeXU4V2VLaHc5VQ=="
    }
  }
}
EOF

echo "✅ Docker registry authentication configured!"
echo "🐳 Registry: $REGISTRY"
echo "📝 Config file: $DOCKER_CONFIG_FILE"
echo ""
echo "🚀 You can now run: ./deploy.sh"
echo "🔍 Or test login: docker login $REGISTRY" 