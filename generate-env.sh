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

# Copy template
cp .env_template .env

# Function to generate random hex string
generate_hex() {
    openssl rand -hex 32
}

# Function to generate simple password
generate_password() {
    # Generate a pronounceable password for easier initial setup
    echo "$(openssl rand -base64 12 | tr -d "=+/" | cut -c1-8)$(shuf -i 1000-9999 -n 1)"
}

# Replace placeholders with generated values
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    sed -i '' "s/CHANGEME_GENERATE_HEX32/$(generate_hex)/g" .env
    sed -i '' "s/CHANGEME_SECURE_PASSWORD/$(generate_password)/g" .env
else
    # Linux
    sed -i "s/CHANGEME_GENERATE_HEX32/$(generate_hex)/g" .env
    sed -i "s/CHANGEME_SECURE_PASSWORD/$(generate_password)/g" .env
fi

echo "✅ .env file generated successfully!"
echo ""
echo "⚠️  IMPORTANT: You still need to add your API keys:"
echo "   - ROUTER_OPENAI_API_KEY: Get from https://platform.openai.com/api-keys"
echo "   - ROUTER_ANTHROPIC_API_KEY: Get from https://console.anthropic.com/settings/keys"
echo ""
echo "📝 The generated passwords are for development use. For production, use stronger passwords!"