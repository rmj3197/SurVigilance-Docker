FROM renku/renkulab-py:3.11-0.25.0

USER root

# Install Chrome
RUN apt-get install -y wget
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-st

# Install Renku directly from PyPI (latest version or pin a specific one)
RUN pip install --no-cache-dir renku

# Install Python dependencies directly from GitHub
RUN pip install --no-cache-dir "git+https://github.com/rmj3197/SurVigilance.git"
