#!/usr/bin/env bash

echo "(Have you 'docker login --username=bitsophon --email=lab@bitsophon.com' before?)"

# Submit the image
docker push "$1"