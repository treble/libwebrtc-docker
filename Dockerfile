# Build with:
# docker build -t libwebrtc --build-arg WEBRTC_CHECKOUT=<tree_ish>
# 
# WEBRTC_CHECKOUT: branch, tag, or commit to checkout and build

# using debian as base image
FROM debian:buster as builder

# setup required arguments
ARG WEBRTC_CHECKOUT
ENV WEBRTC_CHECKOUT=$WEBRTC_CHECKOUT

# install git, curl, gcc/g++, and python 2
RUN apt-get update && apt-get upgrade -y && apt-get install git curl build-essential python -y

# get depot tools (https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up)
WORKDIR /webrtc
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# add depot tools to PATH
ENV PATH /webrtc/depot_tools:$PATH

# pull libwebrtc
RUN fetch --nohooks webrtc && \
    gclient sync && \
    # checkout specified root
    cd /webrtc/src && \
    git checkout $WEBRTC_CHECKOUT && \
    gclient sync && \
    # purge .git folders (~4 GB saved)
    rm -rf ./.git ./third_party/.git
WORKDIR /webrtc/src

# install build deps
RUN apt-get install lsb-release sudo gcc-arm-linux-gnueabihf g++-8-arm-linux-gnueabihf -y && /webrtc/src/build/install-build-deps.sh

# configure libwebrtc
RUN gn gen /webrtc/out --args='is_debug=false is_component_build=false is_clang=false rtc_include_tests=false rtc_use_h264=true rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false treat_warnings_as_errors=false use_ozone=true'

# build libwebrtc
RUN ninja -C /webrtc/out

# copy some dirs into a smaller image
FROM debian:buster
COPY --from=builder /webrtc/src /webrtc/src
COPY --from=builder /webrtc/out /webrtc/out

# set environment variables for user programs
WORKDIR /webrtc
ENV WEBRTC_SRC_DIR=/webrtc/src WEBRTC_OBJ_DIR=/webrtc/out/obj