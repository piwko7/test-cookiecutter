FROM python:{{cookiecutter.python_version}}-slim-bullseye AS base

LABEL maintainer="Netguru S.A. <hello@netguru.com>"

WORKDIR /app
EXPOSE 80
CMD ["python", "-m", "main", "--port", "80"]

ENV PYTHONUNBUFFERED=1 \
    PYTHONPATH=/app

RUN --mount=type=secret,id=PIP_INDEX_URL PIP_INDEX_URL=$(cat /run/secrets/PIP_INDEX_URL) \
    apt-get update -y \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && pip install pipenv --no-cache-dir

COPY app/Pipfile* /

# Development image
FROM base AS dev
ENV PYTHONPATH=/app

RUN --mount=type=secret,id=PIP_INDEX_URL PIP_INDEX_URL=$(cat /run/secrets/PIP_INDEX_URL) \
    pipenv sync --dev --system

COPY app /app
COPY shared /app/shared

# Production image
FROM base AS prod

RUN --mount=type=secret,id=PIP_INDEX_URL PIP_INDEX_URL=$(cat /run/secrets/PIP_INDEX_URL) \
    pipenv sync  --system

COPY app /app
COPY shared /app/shared
RUN rm -rf /app/tests

# Deployment image
FROM base as final

COPY --from=prod /usr/local/bin /usr/local/bin
COPY --from=prod /usr/local/lib /usr/local/lib
COPY --from=prod /app /app
