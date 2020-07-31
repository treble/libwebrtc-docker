# setup required arguments
#
# Build with:
# docker build --rm -t libwebrtc --build-arg WEBRTC_CHECKOUT_NEW_BRANCH=<new_branch> WEBRTC_CHECKOUT_TREE=<tree_ish>
# 
# WEBRTC_CHECKOUT_TREE: branch, tag, or commit to checkout and build
# WEBRTC_CHECKOUT_NEW_BRANCH: friendly name for the branch to create on checkout (e.g. m84)
ARG WEBRTC_CHECKOUT_NEW_BRANCH
ARG WEBRTC_CHECKOUT_TREE

# using debian as base image
FROM debian:buster as builder

# install git, curl, and gcc/g++
RUN apt-get update && apt-get upgrade -y && apt-get install git curl build-essential -y

# get depot tools (https://commondatastorage.googleapis.com/chrome-infra-docs/flat/depot_tools/docs/html/depot_tools_tutorial.html#_setting_up)
WORKDIR /webrtc
RUN git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git

# add depot tools to PATH
ENV PATH /webrtc/depot_tools:$PATH

# pull libwebrtc
RUN fetch --nohooks webrtc
RUN gclient sync
WORKDIR /webrtc/src
RUN git checkout -b ${WEBRTC_CHECKOUT_NEW_BRANCH} ${WEBRTC_CHECKOUT_TREE}
RUN gclient sync

# configure libwebrtc
RUN gn gen /webrtc/build --args='is_debug=false is_component_build=false is_clang=false rtc_include_tests=false rtc_use_h264=true rtc_enable_protobuf=false use_rtti=true use_custom_libcxx=false treat_warnings_as_errors=false use_ozone=true'

# build libwebrtc
RUN ninja -C /webrtc/out

# set environment variables for user programs
ENV WEBRTC_SRC_DIR /webrtc/src
ENV WEBRTC_OUT_DIR /webrtc/out