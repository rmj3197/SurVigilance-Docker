# Use the specified RenkuLab base image (Python 3.11)
ARG RENKU_BASE_IMAGE=renku/renkulab-py:3.11-7922455
FROM ${RENKU_BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin \
    CHROME_BIN=/usr/bin/google-chrome

# Install system dependencies and Google Chrome
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        git-lfs \
        curl \
        wget \
        gnupg \
        ca-certificates \
        fonts-liberation \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libatspi2.0-0 \
        libdrm2 \
        libgbm1 \
        libgtk-3-0 \
        libnss3 \
        libx11-xcb1 \
        xdg-utils \
    && rm -rf /var/lib/apt/lists/* \
    && git lfs install --system

# Add Google Chrome repository and install Chrome (stable)
RUN install -m 0755 -d /etc/apt/keyrings && \
    wget -qO /etc/apt/keyrings/google-chrome.gpg https://dl.google.com/linux/linux_signing_key.pub && \
    sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y --no-install-recommends google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install pipx
RUN python -m pip install --upgrade pip pipx

# RENKU_VERSION determines the version of the renku CLI
# Set to a specific version (e.g. 2.8.1) or leave empty to install the latest
ARG RENKU_VERSION=

########################################################
# Do not edit this section and do not add anything below

RUN if command -v renku >/dev/null 2>&1; then pipx uninstall renku || true; fi && \
    if [ -n "$RENKU_VERSION" ] ; then \
        pipx install --force "renku==${RENKU_VERSION}"; \
    else \
        pipx install --force renku; \
    fi

USER ${NB_USER}
WORKDIR /workspace

# Default command
CMD ["renku", "--help"]

########################################################