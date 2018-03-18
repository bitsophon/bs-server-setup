#!/usr/bin/env bash
# Params
SERVER_REPOSITORY=git@github.com:bitsophon/bs-server-setup.git
DOCKER_REGISTRY=bitsophon

# Bold text
bold=$(tput bold)
normal=$(tput sgr0)

# Recap
echo "Docker registry: ${bold}$DOCKER_REGISTRY${normal}"

# Build nginx
echo "\n\n${bold}Build nginx image${normal}"
docker build -t "$DOCKER_REGISTRY/nginx" nginx
