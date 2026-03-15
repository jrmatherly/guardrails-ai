# syntax=docker/dockerfile:1
FROM python:3.11-slim

WORKDIR /app

# Install guardrails with API server support
RUN pip install --no-cache-dir "guardrails-ai[api]"

# Configure guardrails and install hub validators
# Use ARG for build-time token (will be in build cache but NOT in final image if using multi-stage)
# For this single-stage build, the token is in layer cache but removed from filesystem
ARG GUARDRAILS_TOKEN
RUN guardrails configure \
      --token "${GUARDRAILS_TOKEN}" \
      --enable-metrics false \
      --enable-remote-inferencing false \
      --no-banner && \
    guardrails hub install hub://guardrails/toxic_language && \
    guardrails hub install hub://guardrails/nsfw_text && \
    guardrails hub install hub://guardrails/detect_secrets && \
    rm -f /root/.guardrailsrc

# Copy guard configuration
COPY config.py /app/config.py

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--timeout", "90", "--workers", "2", "--threads", "4", "guardrails_api.app:create_app(None, 'config.py')"]
