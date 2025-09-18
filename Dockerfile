# Dockerfile for GenLayer Validator
FROM debian:12-slim

ARG GENLAYER_VERSION=v0.3.10
WORKDIR /opt/genlayer

# Install dependencies
RUN apt-get update &&     apt-get install -y curl wget tar ca-certificates &&     rm -rf /var/lib/apt/lists/*

# Download GenLayer release
RUN wget https://storage.googleapis.com/gh-af/genlayer-node/bin/amd64/${GENLAYER_VERSION}/genlayer-node-linux-amd64-${GENLAYER_VERSION}.tar.gz -O /tmp/genlayer.tar.gz &&     tar -xzvf /tmp/genlayer.tar.gz -C /opt/genlayer --strip-components=1 &&     rm /tmp/genlayer.tar.gz

# Add binary to PATH
ENV PATH="/opt/genlayer/bin:${PATH}"

# Default volumes for data/config/logs
VOLUME ["/opt/genlayer/configs", "/opt/genlayer/data", "/opt/genlayer/logs"]

# Expose RPC / Admin / Ops ports
EXPOSE 9151 9153 9155

ENTRYPOINT ["genlayernode"]
CMD ["--help"]
