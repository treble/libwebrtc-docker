#!/bin/bash -e

# This is only for the project maintainer(s). Please run `docker login` first.

# build configuration
TAG=m84

# change to this file's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
pushd $DIR

# build the docker image
./build.sh

# upload the docker image
docker tag libwebrtc:$TAG treblestudio/libwebrtc:$TAG
docker push treblestudio/libwebrtc:$TAG

popd