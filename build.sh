#!/bin/sh

export DOCKER_CLI_EXPERIMENTAL=enabled

docker buildx build -f Dockerfile -t v2log:v2 --platform linux/amd64 .
