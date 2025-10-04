FROM renku/renkulab-py:3.11-0.25.0

USER root

# Install Google Chrome
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        gnupg \
        apt-transport-https && \
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-linux.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        google-chrome-stable \
        libglib2.0-0 \
        libnss3 \
        libgconf-2-4 && \
    rm -rf /var/lib/apt/lists/*

# Install Renku directly from PyPI (latest version or pin a specific one)
RUN pip install --no-cache-dir renku

# Install Python dependencies directly from GitHub
RUN pip install --no-cache-dir "git+https://github.com/rmj3197/SurVigilance.git"
