#!/bin/bash

# Generate .env file from .env_template with auto-generated secure values

if [ -f .env ]; then
    echo "⚠️  .env file already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Exiting without changes."
        exit 1
    fi
fi

echo "🔧 Generating .env file from .env_template..."

# Function to generate random hex string
generate_hex() {
    openssl rand -hex 32
}

# Function to generate simple password
generate_password() {
    # Generate a pronounceable password for easier initial setup
    echo "$(openssl rand -base64 12 | tr -d "=+/" | cut -c1-8)$(shuf -i 1000-9999 -n 1)"
}

# Start with template
cat > .env << 'EOF'
# Domain configuration
ROOT_DOMAIN=project.docker
CLOUDFLARE_IPS=173.245.48.0/20,103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,141.101.64.0/18,108.162.192.0/18,190.93.240.0/20,188.114.96.0/20,197.234.240.0/22,198.41.128.0/17,162.158.0.0/15,104.16.0.0/13,104.24.0.0/14,172.64.0.0/13,131.0.72.0/22
LOCAL_IPS=127.0.0.1/32,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12
TZ=UTC
EOF

# Add database configuration with standard naming
cat >> .env << 'EOF'

# LLM Router Database (LiteLLM)
LLM_ROUTER_DB=litellm
LLM_ROUTER_DB_USER=litellm
EOF
echo "LLM_ROUTER_DB_PASSWORD=$(generate_hex)" >> .env

# Add LiteLLM configuration
cat >> .env << 'EOF'

# LiteLLM Configuration
EOF
echo "LITELLM_MASTER_KEY=$(generate_hex)" >> .env
echo "LITELLM_SALT_KEY=$(generate_hex)" >> .env
echo "LITELLM_UI_USERNAME=admin" >> .env
echo "LITELLM_UI_PASSWORD=$(generate_password)" >> .env

# Add API keys - check environment first
cat >> .env << 'EOF'

# API Keys for Model Providers
EOF

# Check for OpenAI key in environment
if [ -n "$OPENAI_API_KEY" ]; then
    echo "ROUTER_OPENAI_API_KEY=$OPENAI_API_KEY" >> .env
    echo "   ✅ Found OpenAI API key in environment"
else
    echo "# Get from: https://platform.openai.com/api-keys" >> .env
    echo "ROUTER_OPENAI_API_KEY=sk-CHANGEME_YOUR_OPENAI_KEY" >> .env
fi

# Check for Anthropic key in environment
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo "ROUTER_ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY" >> .env
    echo "   ✅ Found Anthropic API key in environment"
else
    echo "" >> .env
    echo "# Get from: https://console.anthropic.com/settings/keys" >> .env
    echo "ROUTER_ANTHROPIC_API_KEY=sk-CHANGEME_YOUR_ANTHROPIC_KEY" >> .env
fi

# Check for Hugging Face key in environment
if [ -n "$HUGGING_FACE_HUB_TOKEN" ]; then
    echo "" >> .env
    echo "HUGGING_FACE_HUB_TOKEN=$HUGGING_FACE_HUB_TOKEN" >> .env
    echo "   ✅ Found Hugging Face API key in environment"
else
    echo "" >> .env
    echo "# Hugging Face API Key" >> .env
    echo "# Get from: https://huggingface.co/settings/tokens" >> .env
    echo "HUGGING_FACE_HUB_TOKEN=hf_CHANGEME_YOUR_HUGGING_FACE_API_KEY" >> .env
fi

# Add Chat UI database configuration
cat >> .env << 'EOF'

# Chat UI Database (OpenWebUI)
CHAT_UI_DB=openwebui
CHAT_UI_DB_USER=openwebui
EOF
echo "CHAT_UI_DB_PASSWORD=$(generate_hex)" >> .env
echo "CHAT_UI_SECRET_KEY=$(generate_hex)" >> .env

# Add Qdrant configuration
cat >> .env << 'EOF'

# Vector Database (Qdrant)
EOF
echo "QDRANT__SERVICE__API_KEY=$(generate_hex)" >> .env

echo ""
echo "✅ .env file generated successfully!"
echo ""
echo "📋 Configuration summary:"
echo "   - Timezone: UTC"
echo "   - Domain: project.docker"

# Check which API keys still need to be added
missing_keys=""
if [ -z "$OPENAI_API_KEY" ] && grep -q "CHANGEME_YOUR_OPENAI_KEY" .env; then
    missing_keys="$missing_keys\n   - ROUTER_OPENAI_API_KEY: Get from https://platform.openai.com/api-keys"
fi
if [ -z "$ANTHROPIC_API_KEY" ] && grep -q "CHANGEME_YOUR_ANTHROPIC_KEY" .env; then
    missing_keys="$missing_keys\n   - ROUTER_ANTHROPIC_API_KEY: Get from https://console.anthropic.com/settings/keys"
fi
if [ -z "$HUGGING_FACE_HUB_TOKEN" ] && grep -q "CHANGEME_YOUR_HUGGING_FACE_API_KEY" .env; then
    missing_keys="$missing_keys\n   - HUGGING_FACE_HUB_TOKEN: Get from https://huggingface.co/settings/tokens"
fi

if [ -n "$missing_keys" ]; then
    echo ""
    echo "⚠️  IMPORTANT: You still need to add your API keys:"
    echo -e "$missing_keys"
fi

echo ""
echo "📝 The generated passwords are for development use. For production, use stronger passwords!"