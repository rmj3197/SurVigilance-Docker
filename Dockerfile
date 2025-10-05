# syntax=docker/dockerfile:1.6
FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV SHELL=/bin/bash \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    CHROME_BIN=/usr/bin/google-chrome

# Base deps + ttyd
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl gnupg bash sudo git procps wget \
        libasound2 libnss3 libxss1 libatk-bridge2.0-0 libatk1.0-0 \
        libgtk-3-0 libgbm1 xdg-utils fonts-liberation libu2f-udev \
        libvulkan1 xdg-user-dirs \
        ttyd \
    && rm -rf /var/lib/apt/lists/*

# Google Chrome repo + install
RUN mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
        | gpg --dearmor -o /etc/apt/keyrings/google-linux.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-linux.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd -m -u 1000 -s /bin/bash renku \
    && echo "renku ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/renku \
    && chmod 0440 /etc/sudoers.d/renku

USER renku
WORKDIR /home/renku

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -fsS http://127.0.0.1:8080/ || exit 1

# Launch a web terminal on port 8080
CMD ["ttyd","--port","8080","--cwd","/home/renku","bash"]
