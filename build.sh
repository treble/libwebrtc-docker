#!/bin/bash -e

# build configuration
TAG=m84
WEBRTC_CHECKOUT=refs/remotes/branch-heads/4147

# change to dir containing this file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

# build the docker image
docker build -t --rm libwebrtc:$TAG --build-arg WEBRTC_CHECKOUT=$WEBRTC_CHECKOUT .

popd