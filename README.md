# Guardrails AI Server

Custom Guardrails AI server image for the Talos AI Cluster LiteLLM proxy.

## Guards Included

- **toxic-language-guard** — ML-based toxic language detection (transformer model)
- **nsfw-content-guard** — NSFW/sexual content detection (classifier)
- **detect-secrets-guard** — API key, token, and password detection (regex-based)

## Usage

```bash
docker build -t ghcr.io/jrmatherly/guardrails-ai:latest .
docker push ghcr.io/jrmatherly/guardrails-ai:latest
```

## Integration

This image is deployed as a Kubernetes Deployment in the `ai` namespace, consumed by LiteLLM via the `guardrails_ai` integration. The LiteLLM integration explicitly skips embedding requests — only chat completions are validated.

Port: 8000
Health endpoint: `/health`
