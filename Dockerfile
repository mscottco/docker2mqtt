FROM python:3.12
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install docker
RUN apt update && \
    apt install --no-install-recommends -y apt-transport-https ca-certificates curl software-properties-common && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt update && \
    apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/*


# Pre-reqs
RUN apt update && \
    apt install --no-install-recommends -y python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Copy files into place
COPY requirements.txt /

RUN pip install -r requirements.txt --break-system-packages

# Copy files into place
COPY docker2mqtt /

# Pass correct stop signal to script
STOPSIGNAL SIGINT

# Set the entrypoint
ENTRYPOINT ["/docker2mqtt"]
