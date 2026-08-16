#!/bin/sh

TAG=$(head -n1 ReleaseTag)

export DOCKER_CLI_EXPERIMENTAL=enabled

docker buildx build -f Dockerfile --build-arg TAG=${TAG} -t v2log:${TAG} --platform linux/amd64 .
