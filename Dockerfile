# syntax=docker/dockerfile:1
FROM python:3.11-slim

WORKDIR /app

# Install guardrails with API server support
RUN pip install --no-cache-dir "guardrails-ai[api]"

# Configure guardrails Hub auth and install validators
# Uses Typer boolean toggle flags: --disable-metrics (not --enable-metrics false)
# Token is used at build time only; .guardrailsrc is removed after hub installs
ARG GUARDRAILS_TOKEN
RUN guardrails configure \
      --token "${GUARDRAILS_TOKEN}" \
      --disable-metrics \
      --disable-remote-inferencing && \
    guardrails hub install hub://guardrails/toxic_language && \
    guardrails hub install hub://guardrails/nsfw_text && \
    guardrails hub install hub://guardrails/secrets_present && \
    rm -f /root/.guardrailsrc

# Copy guard configuration
COPY config.py /app/config.py

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--timeout", "90", "--workers", "2", "--threads", "4", "guardrails_api.app:create_app(None, 'config.py')"]
