FROM python:{{cookiecutter.python_version}}-slim as core

LABEL maintainer="Netguru S.A. <hello@netguru.com>"

WORKDIR /app
ENV PYTHONUNBUFFERED=1

RUN --mount=type=secret,id=PIP_INDEX_URL PIP_INDEX_URL=$(cat /run/secrets/PIP_INDEX_URL) \
    apt-get update -y \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && pip install pipenv --no-cache-dir

COPY app/Pipfile* /

RUN --mount=type=secret,id=PIP_INDEX_URL PIP_INDEX_URL=$(cat /run/secrets/PIP_INDEX_URL) \
    pipenv sync  --system

# Development image
FROM base AS dev
EXPOSE 80
ENV PYTHONPATH=/app

RUN --mount=type=secret,id=PIP_INDEX_URL PIP_INDEX_URL=$(cat /run/secrets/PIP_INDEX_URL) \
    pipenv sync --dev --system

COPY app /app

# Production image
FROM base AS prod

COPY app /app
RUN rm -rf /app/tests

# Deployment image
FROM python:3.11-slim

ENV PYTHONUNBUFFERED=1 PYTHONPATH=/app
WORKDIR /app

COPY --from=prod /usr/local/bin /usr/local/bin
COPY --from=prod /usr/local/lib /usr/local/lib
COPY --from=prod /app /app

EXPOSE 80
CMD ["python", "-m", "main", "--port", "80"]
