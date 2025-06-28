---
title: 'LLM-in-a-Box: A Templated, Self-Hostable Framework for Generative AI in Research'
tags:
  - Python
  - Docker
  - LLM
  - generative AI
  - self-hosting
  - reproducible research
  - RSE
  - ollama
  - litellm
  - docling
  - qdrant
  - traefik
  - secops
  - sops
  - age
authors:
  - name: Georg Heiler
    orcid: 0000-0002-8684-1163
    affiliation: "1, 2"
  - name: Aaron Culich
    affiliation: 3
affiliations:
 - name: Complexity Science Hub Vienna (CSH)
   index: 1
 - name: Austrian Supply Chain Intelligence Institute (ASCII)
   index: 2
 - name: Eviction Research Network at University of California, Berkeley
   index: 3
date: 1st July 2025
bibliography: paper.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# <https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
aas-journal: Journal of Open Source Education
---

# Summary

The proliferation of Large Language Models (LLMs) has created significant opportunities for innovation across all research domains.
However, accessing these powerful tools effectively besides the consumer oriented flagship products (chatgpt, claude workspace) presents a substantial challenge.
Researchers are often faced with a choice between relying on proprietary, cloud-based APIs—which can introduce concerns regarding cost, data privacy, and scientific reproducibility — or undertaking the complex engineering task of self-hosting open-source models.
This reliance on a few dominant providers creates new, powerful gatekeeper functions; whoever controls the LLM interface can dictate which tools a user sees, what responses are surfaced, and even whether a third-party tool can be installed in the first place [@graham_mcps_2025].
The technical barrier to the alternative, self-hosting, often requires dedicated support from Research Software Engineers (RSEs), a role that is crucial but not always available to every research group [@hettrick2013uk].

LLM-in-a-Box is a templated project designed to democratize access to generative AI for the research community.
It provides a cohesive, containerized stack of open-source tools that can be deployed with minimal configuration, effectively packaging the expertise of an RSE into a reusable template.
The project integrates a flexible chat interface (OpenWebUI  [@openwebui]), a powerful model server for self-hosting (Ollama  [@ollama]), and a universal model router (LiteLLM  [@litellm]) that unifies access to both local and commercial models through a single API endpoint and docling [@auer2024doclingtechnicalreport] for effective high-quality retrieval-augmented-generation RAG pipelines.
This architecture directly addresses the dire need for a flexible and sovereign compute environment, allowing researchers to seamlessly switch between models from providers like OpenAI and Anthropic and self-hosted models like Llama3 or Gemma for both chat and programmatic access.

By providing a stable, well-documented, and easily updatable foundation using tools like docker compose and cruft, LLM-in-a-Box lowers the barrier to entry for advanced AI/ML workflows.
This enables researchers to focus on their scientific questions rather than on infrastructure, while ensuring that their methods remain transparent, private, and reproducible.

# Statement of Need 

The responsible application of LLMs in research necessitates infrastructure that is both powerful and flexible.
Commercial API-based models are convenient but can be a black box, with models and terms changing without notice, jeopardizing long-term reproducibility.
Furthermore, research involving sensitive data (e.g., in medicine, social sciences, or proprietary industrial research) cannot be sent to third-party services.
Self-hosting is the clear solution, but it traditionally involves a complex orchestration of multiple services: a model serving engine, a user interface, routing logic, and data persistence. 

LLM-in-a-Box was created to fill this gap.
It provides a pre-configured environment that solves the integration challenge, making robust, self-hosted generative AI capabilities accessible to research groups, educational institutions, and individual developers. By including docling for document extraction, it also offers a clear pathway to implementing sophisticated Retrieval-Augmented Generation (RAG) workflows, a critical technique for grounding model outputs in specific, verifiable sources of information.
This template empowers researchers to build and control their own AI ecosystem, which is fundamental for scientific integrity and innovation in the age of generative AI. 

# Example usage

Prerequisites:

- You have a working installation of pixi available. See https://pixi.sh/latest/ for installing
- An OCI compliant container runtime like docker desktop
- git

```bash
git clone git@github.com:complexity-science-hub/llm-in-a-box-template.git
cd llm-in-a-box-template
pixi run tpl-init
```
Change into your freshly generated instance of the tempalte project.
Then: Set up your secrets in the `.env` file.
You fin an example configration directly in the [README.md](https://github.com/complexity-science-hub/llm-in-a-box-template/blob/main/README.md) file.
Make sure to not use dummy secrets - generate secure ones via i.e. `openssl rand -hex 32` for each secret.
Please read [the secops instructions](https://github.com/complexity-science-hub/llm-in-a-box-template/blob/main/%7B%7Bcookiecutter.project_slug%7D%7D/documentation/secops/add-key.md) to understand how to manage secrets easily.


Then you can start the template project with:
```bash
# cpu
docker compose --profile llminabox --profile ollama-cpu --profile docling-cpu --profile vectordb-cpu up -d

# gpu
docker compose --profile llminabox --profile ollama-gpu --profile docling-gpu --profile vectordb-cpu up -d
```

Please follow along with the [README.md](https://github.com/complexity-science-hub/llm-in-a-box-template/blob/main/README.md) file from here.

# Impact and future work

LLM‑in‑a‑Box has already been adopted inside the Complexity Science Hub.
Planned enhancements include a FluxCD‑based Kubernetes deployment which bootsraps SSL as well.
We welcome community pull requests to extend this project.

# Acknowledgements

This project stands on the shoulders of giants in the open-source community.
We explicitly acknowledge the creators and maintainers of the core components of this stack: llamacpp, Ollama, LiteLLM, OpenWebUI, Traefik, docker, docling, sops, age, qdrant, and Postgres.
Their work makes projects like this possible.

# References