#!/usr/bin/env bash

# NameSpace
SERVER_REPOSITORY=git@github.com:bitsophon/bs-server-setup.git
DOCKER_REGISTRY=bitsophon

# Bold text
bold=$(tput bold)
normal=$(tput sgr0)

# Get the git branch/tag
branch=$1
if [ "$branch" = "" ] ; then
	branch="master"
fi

# Recap
echo "Git branch/tag: ${bold}$branch${normal}"
echo "Repository: ${bold}$SERVER_REPOSITORY${normal}"
echo "Docker registry: ${bold}$DOCKER_REGISTRY${normal}"

# Build nginx
echo "\n\n${bold}Build CentOS 7 image${normal}"
docker build -t "$DOCKER_REGISTRY/centos7" centos
# docker tag -f "$DOCKER_REGISTRY/whalesay:latest" "$DOCKER_REGISTRY/whalesay:latest"
