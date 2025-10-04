# Use the specified base image
FROM ghcr.io/swissdatasciencecenter/renku/py-basic-ttyd:2.8.0

# Install dependencies and Google Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    --no-install-recommends && \
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify installation
RUN google-chrome --version

# Default command
CMD ["/bin/bash"]