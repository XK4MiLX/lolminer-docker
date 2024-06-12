FROM nvidia/cuda:12.4.1-base-ubuntu22.04 as nvidia

ENV DEBIAN_FRONTEND=noninteractive
ARG LOLMINER_VERSION=1.88

RUN apt-get update && \
    apt-get install -y wget tar curl libcurl4 && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Lolliedieb/lolMiner-releases/releases/download/${LOLMINER_VERSION}/lolMiner_v${LOLMINER_VERSION}_Lin64.tar.gz -O /tmp/lolMiner.tar.gz && \
    mkdir -p /opt/lolminer && \
    tar --strip-components=1 -xvf /tmp/lolMiner.tar.gz -C /opt/lolminer && \
    rm /tmp/lolMiner.tar.gz

# Make the lolMiner binary executable
RUN chmod +x /opt/lolminer/lolMiner

# Copy the entrypoint script into the image
COPY entrypoint.sh /opt/lolminer/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /opt/lolminer/entrypoint.sh

# Set working directory
WORKDIR /opt/lolminer

# Define environment variables with default values
ENV ALGO=""
ENV POOL=""
ENV WALLET=""
ENV EXTRA=""

# Set the entrypoint to the entrypoint script
ENTRYPOINT ["/opt/lolminer/entrypoint.sh"]
