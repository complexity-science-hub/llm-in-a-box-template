# VLLM

Ensure the desired version of VLMM is selected here.

## initial setup

```
git clone --branch v0.9.1 --depth 1 https://github.com/vllm-project/vllm.git

# alternatively
git submodule add https://github.com/vllm-project/vllm.git vllm
cd vllm
git checkout v0.9.1
```

## updating a new version of vllm

Ensure the right version is set in docker compose: `SETUPTOOLS_SCM_PRETEND_VERSION_FOR_VLLM: "0.9.1"`

```bash
# 1. Navigate into the submodule directory
cd services/model-server/vllm

# 2. Add the original vLLM repo as a new remote called "upstream"
git remote add upstream https://github.com/vllm-project/vllm.git

# 3. Verify that it's set up correctly
git remote -v

git fetch upstream
git fetch upstream --tags

# ensure we are on our hotfixed branch
# ba28a8452b4e278b7da4e7a1eb1bc5a334a755ca
git checkout template-git-fix

# git rebase upstream/main
# This is the key command. Read it as:
# "Rebase ONTO v0.9.2, all commits that are on my current branch (template-git-fix)
#  since it diverged from v0.9.1."
git rebase --onto v0.9.2 v0.9.1 template-git-fix

git push --force-with-lease origin template-git-fix

git add services/model-server/vllm
git commit -m "chore: Update vllm submodule to v<TODO set version> from upstream"
git push
```

## gpu vs cpu

```
docker run --runtime nvidia --gpus all \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    --env "HUGGING_FACE_HUB_TOKEN=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" \
    -p 8000:8000 \
    --ipc=host \
    vllm/vllm-openai:latest \
    --model mistralai/Mistral-7B-v0.1

docker run --privileged \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    --env "HUGGING_FACE_HUB_TOKEN=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" \
    -p 8000:8000 \
    --ipc=host \
    public.ecr.aws/q9t5s3a7/vllm-cpu-release-repo:v0.9.1 \
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

```