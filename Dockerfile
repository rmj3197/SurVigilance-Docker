FROM renku/renkulab-py:3.11-0.25.0

USER root

# Install Google Chrome
# Install Google Chrome (bookworm/bullseye friendly)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        gnupg \
        apt-transport-https; \
    install -m 0755 -d /etc/apt/keyrings; \
    wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
      | gpg --dearmor -o /etc/apt/keyrings/google-linux-signing-keyring.gpg; \
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-linux-signing-keyring.gpg] https://dl.google.com/linux/chrome/deb/ stable main" \
      > /etc/apt/sources.list.d/google-chrome.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        google-chrome-stable \
        libglib2.0-0 \
        libnss3 \
        libxss1 \
        libgtk-3-0 \
        libxdamage1 \
        libxrandr2 \
        libasound2 \
        libgbm1 \
        xdg-utils \
        fonts-liberation \
        libu2f-udev; \
    rm -rf /var/lib/apt/lists/*

# Install Renku directly from PyPI (latest version or pin a specific one)
RUN pip install --no-cache-dir renku

# Install Python dependencies directly from GitHub
RUN pip install --no-cache-dir "git+https://github.com/rmj3197/SurVigilance.git"
