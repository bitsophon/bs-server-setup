#!/usr/bin/env bash
# Params
SERVER_REPOSITORY=git@github.com:bitsophon/bs-server-setup.git
DOCKER_REGISTRY=bitsophon
DATE_TAG=`date +%Y%m%d%H%M`

# Bold text
bold=$(tput bold)
normal=$(tput sgr0)

# Recap
echo "Docker registry: ${bold}$DOCKER_REGISTRY${normal}"

# Build bitsophon-proxy
echo "\n\n${bold}Build cipherbank-proxy image${normal}"
docker build -t "$DOCKER_REGISTRY/bitsophon-proxy" bitsophon-proxy
docker tag "$DOCKER_REGISTRY/bitsophon-proxy:latest" "$DOCKER_REGISTRY/bitsophon-proxy:$DATE_TAG"
