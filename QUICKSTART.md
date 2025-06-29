# LLM in a Box - Quick Start Guide

This guide provides a comprehensive step-by-step process to get the LLM in a Box stack up and running quickly with Docker Compose.

## Prerequisites

### 1. Install Pixi (Package Manager)

Pixi is required to manage dependencies and tooling.

**macOS/Linux:**
```bash
curl -fsSL https://pixi.sh/install.sh | sh
```

**Windows:**
```powershell
powershell -ExecutionPolicy ByPass -c "irm -useb https://pixi.sh/install.ps1 | iex"
```

📖 **Documentation:** https://pixi.sh/latest/

### 2. Install Docker

You need a container runtime. Choose one of:

- **Docker Desktop** (Recommended for beginners)
  - Download: https://www.docker.com/products/docker-desktop/
  - Includes Docker Compose

- **Rancher Desktop** (Alternative)
  - Download: https://rancherdesktop.io/
  - Open source alternative to Docker Desktop

After installation, verify Docker is working:
```bash
docker --version
docker compose version
```

## Initial Setup

### 1. Clone and Enter the Repository

```bash
# If you haven't cloned yet
git clone <your-repo-url>
cd llm-in-a-box-template

# Switch to develop branch
git checkout develop
```

### 2. Set Up Environment Variables

We've created an automated script to generate your `.env` file with secure values:

```bash
# Generate .env from template
./generate-env.sh
```

This will create a `.env` file with:
- Auto-generated secure passwords and keys
- Pre-configured domain settings for `project.docker`
- Automatically detected timezone
- API keys from your environment (if OPENAI_API_KEY or ANTHROPIC_API_KEY are set)
- Standard database naming conventions (litellm, openwebui)

### 3. Add Your API Keys

You'll need to manually add API keys for the AI models you want to use:

#### OpenAI API Key
1. Go to: https://platform.openai.com/api-keys
2. Click "Create new secret key"
3. Copy the key (starts with `sk-`)
4. Edit `.env` and replace `sk-CHANGEME_YOUR_OPENAI_KEY` with your key

#### Anthropic (Claude) API Key
1. Go to: https://console.anthropic.com/settings/keys
2. Click "Create Key"
3. Copy the key (starts with `sk-ant-`)
4. Edit `.env` and replace `sk-CHANGEME_YOUR_ANTHROPIC_KEY` with your key

#### Other Providers (Optional)
- **Google Gemini**: https://aistudio.google.com/apikey
- **Vertex AI**: Requires GCP project setup

## Configure Local Domain

To use `project.docker` instead of localhost, add this to your hosts file:

**macOS/Linux:**
```bash
echo "127.0.0.1 project.docker" | sudo tee -a /etc/hosts
echo "127.0.0.1 llm.project.docker" | sudo tee -a /etc/hosts
echo "127.0.0.1 chat.project.docker" | sudo tee -a /etc/hosts
```

**Windows (Run as Administrator):**
```powershell
Add-Content C:\Windows\System32\drivers\etc\hosts "127.0.0.1 project.docker"
Add-Content C:\Windows\System32\drivers\etc\hosts "127.0.0.1 llm.project.docker"
Add-Content C:\Windows\System32\drivers\etc\hosts "127.0.0.1 chat.project.docker"
```

## Start the Services

### CPU-Only Setup (Recommended for Testing)

```bash
docker compose --profile llminabox --profile ollama-cpu --profile docling-cpu --profile vectordb-cpu up -d
```

### GPU Setup (For Better Performance)

```bash
docker compose --profile llminabox --profile ollama-gpu --profile docling-gpu --profile vectordb-cpu up -d
```

Monitor the logs:
```bash
docker compose logs -f
```

## Initial Configuration

### 1. Pull a Local Model (Ollama)

First, let's download a model to test with:

```bash
# Pull a small, fast model for testing
docker exec -it ollama ollama pull gemma2:2b

# Or pull a larger, more capable model
docker exec -it ollama ollama pull llama3.2:3b

# Verify the model is downloaded
docker exec -it ollama ollama list
```

### 2. Configure the Model Router (LiteLLM)

1. Open: http://llm.project.docker/ui
2. Login with credentials from your `.env`:
   - Username: `admin` (or what you set for `LITELLM_UI_USERNAME`)
   - Password: (check `LITELLM_UI_PASSWORD` in your `.env`)

3. Register your local Ollama model:
   - Click "Add Model"
   - Configure:
     ```yaml
     model_name: "gemma2:2b"
     litellm_params:
       model: "ollama_chat/gemma2:2b"
       api_base: "http://ollama:11434"
     ```

4. Register external models (if you added API keys):
   - OpenAI models are auto-detected if API key is set
   - For Claude, add models like `claude-3-sonnet-20240229`

5. Create an API key for the Chat UI:
   - Go to "Keys" section
   - Click "Create Key"
   - Name: `chat-ui-key`
   - Select all models you want to make available
   - Copy the generated key

### 3. Configure the Chat UI (Open WebUI)

1. Open: http://chat.project.docker
2. Create an admin account:
   - Username: `admin`
   - Email: `admin@example.com`
   - Password: (choose a secure password)

3. Configure model connection:
   - Go to Admin Settings → Connections
   - Add OpenAI-compatible connection:
     - URL: `http://llmrouter:4000/v1`
     - API Key: (paste the key from LiteLLM)
   - Disable the default OpenAI connection

4. Verify models are available:
   - Go to the chat interface
   - Check that your models appear in the model selector

## Testing Your Setup

1. **Test Ollama directly:**
   ```bash
   docker exec -it ollama ollama run gemma2:2b "Hello, how are you?"
   ```

2. **Test via LiteLLM:**
   - Go to http://llm.project.docker/ui
   - Use the Playground to test models

3. **Test via Chat UI:**
   - Go to http://chat.project.docker
   - Start a new chat and select a model

## Service URLs

- **Chat Interface**: http://chat.project.docker
- **Model Router UI**: http://llm.project.docker/ui
- **Model Router API**: http://llm.project.docker/v1

## Troubleshooting

### Services not starting?
```bash
# Check service status
docker compose ps

# View detailed logs
docker compose logs [service-name]

# Common services: ollama, llmrouter, chatui, routerdb, chatuidb
```

### Can't access URLs?
- Ensure hosts file is updated (see Configure Local Domain)
- Check if ports 80 is available: `lsof -i :80` (macOS/Linux)
- Try accessing via localhost: http://localhost instead

### Models not showing up?
1. Ensure models are pulled in Ollama
2. Restart the model router after adding models:
   ```bash
   docker compose restart llmrouter
   ```

### Database connection issues?
- Wait a few moments for databases to initialize
- Check database logs: `docker compose logs routerdb chatuidb`

## Next Steps

1. **Add more models**: Explore https://ollama.com/library for more models
2. **Configure document extraction**: The Docling service enables advanced RAG capabilities
3. **Set up vector search**: Qdrant is included for semantic search
4. **Production setup**: 
   - Enable HTTPS with proper certificates
   - Configure authentication (Keycloak is included but disabled)
   - Set stronger passwords in `.env`

## Useful Commands

```bash
# Stop all services
docker compose down

# Stop and remove all data
docker compose down -v

# Update services
docker compose pull
docker compose up -d

# View resource usage
docker stats

# Execute commands in containers
docker exec -it ollama /bin/bash
docker exec -it llmrouter /bin/bash
```

## Support

- Check the main README for architectural details
- Report issues at: https://github.com/anthropics/claude-code/issues
- LiteLLM docs: https://docs.litellm.ai/
- Open WebUI docs: https://docs.openwebui.com/
- Ollama docs: https://ollama.com/