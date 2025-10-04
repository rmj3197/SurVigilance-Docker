########################################################
#        Renku install section - do not edit           #

FROM renku/renkulab-py:3.11-0.25.0 as builder

ARG RENKU_VERSION={{ __renku_version__ | default("2.7.0") }}

# Install the desired Renku version into the virtualenv
RUN if [ -n "$RENKU_VERSION" ] ; then \
        source /root/.renku/venv/bin/activate ; \
        currentversion=$(renku --version) ; \
        if [ "$RENKU_VERSION" != "$currentversion" ] ; then \
            pip uninstall renku -y ; \
            gitversion=$(echo "$RENKU_VERSION" | sed -n "s/^[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]\+\(rc[[:digit:]]\+\)*\(\.dev[[:digit:]]\+\)*\(+g\([a-f0-9]\+\)\)*\(+dirty\)*$/\4/p") ; \
            if [ -n "$gitversion" ] ; then \
                pip install --no-cache-dir --force "git+https://github.com/SwissDataScienceCenter/renku-python.git@$gitversion" ;\
            else \
                pip install --no-cache-dir --force renku==${RENKU_VERSION} ;\
            fi \
        fi \
    fi

########################################################
#             End Renku install section               #
########################################################

FROM renku/renkulab-py:3.11-0.25.0

# Work as root (no jovyan)
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

# Install Python dependencies directly from GitHub
RUN pip install --no-cache-dir "git+https://github.com/rmj3197/SurVigilance.git"

# Copy the Renku virtual environment from the builder stage
COPY --from=builder ${HOME}/.renku/venv ${HOME}/.renku/venv
