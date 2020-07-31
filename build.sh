#!/bin/bash -e

# change to dir containing this file
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

# build the docker image
docker build --rm -t libwebrtc:m84 --build-arg WEBRTC_CHECKOUT_NEW_BRANCH=m84 --build-arg WEBRTC_CHECKOUT_TREE=refs/remotes/branch-heads/4147 .

popd