#!/bin/sh

set -e
TAG_NAME=${1:-latest}
IMAGE_NAME="darthsim/imgproxy-base:$TAG_NAME"

echo "Image name: $IMAGE_NAME"

export DOCKER_CLI_EXPERIMENTAL=enabled

docker push $IMAGE_NAME-amd64
docker push $IMAGE_NAME-arm64

docker manifest create $IMAGE_NAME -a $IMAGE_NAME-amd64 -a $IMAGE_NAME-arm64
docker manifest annotate $IMAGE_NAME $IMAGE_NAME-amd64 --arch amd64
docker manifest annotate $IMAGE_NAME $IMAGE_NAME-arm64 --arch arm64 --variant v8
docker manifest push $IMAGE_NAME
