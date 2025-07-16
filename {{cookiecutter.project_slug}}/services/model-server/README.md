# VLLM

Ensure the desired version of VLMM is selected here.

## initial setup

```
git clone --branch v0.9.2 --depth 1 https://github.com/vllm-project/vllm.git

# alternatively
git submodule add https://github.com/vllm-project/vllm.git vllm
cd vllm
git checkout v0.9.2
```

## gpu vs cpu

```
docker run --runtime nvidia --gpus all \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    --env "HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN}" \
    -p 8000:8000 \
    --ipc=host \
    vllm/vllm-openai:latest \
    --model mistralai/Mistral-7B-v0.1

docker run --privileged \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    --env "HUGGING_FACE_HUB_TOKEN=${HUGGING_FACE_HUB_TOKEN}" \
    -p 8001:8000 \
    --ipc=host \
    public.ecr.aws/q9t5s3a7/vllm-cpu-release-repo:v0.9.2 \
    --model mistralai/Mistral-7B-v0.1

curl http://localhost:8000/v1/models
curl http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "mistralai/Mistral-7B-v0.1",
    "prompt": "San Francisco is a",
    "max_tokens": 7,
    "temperature": 0
  }'

curl http://localhost:8000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "microsoft/Phi-4-mini-instruct",
    "prompt": "San Francisco is a",
    "max_tokens": 7,
    "temperature": 0
  }'
```