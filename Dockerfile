# syntax=docker/dockerfile:1
FROM python:3.11-slim

WORKDIR /app

# Install guardrails with API server support
RUN pip install --no-cache-dir "guardrails-ai[api]"

# Install hub validators using BuildKit secret mount
# Write config as simple key=value (no INI section headers)
# The secret mount is ephemeral — token is NOT in final image layers
RUN --mount=type=secret,id=guardrails_token \
    mkdir -p /root && \
    echo "token=$(cat /run/secrets/guardrails_token)" > /root/.guardrailsrc && \
    echo "use_remote_inferencing=false" >> /root/.guardrailsrc && \
    echo "enable_metrics=false" >> /root/.guardrailsrc && \
    guardrails hub install hub://guardrails/toxic_language && \
    guardrails hub install hub://guardrails/nsfw_text && \
    guardrails hub install hub://guardrails/detect_secrets && \
    rm -f /root/.guardrailsrc

# Copy guard configuration
COPY config.py /app/config.py

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--timeout", "90", "--workers", "2", "--threads", "4", "guardrails_api.app:create_app(None, 'config.py')"]
