# WebRTC for Docker
Docker container with development- and production-ready builds of libwebrtc

This repository provides Docker images of versioned WebRTC builds, containing all source files and binaries built with sane presets. **Everything except git history is included**, totaling around 8-10GB per image.

## Usage

**Develop WebRTC-based projects locally** by mounting the volume to your disk

```
# Example for Linux
docker volume create libwebrtc-volume
docker run -d -it -v libwebrtc-volume:/webrtc libwebrtc:<TAG>
docker inspect --type volume libwebrtc-volume
cd <Mountpoint from above command>
```

**Build Docker images that use WebRTC** without installing the WebRTC toolchain locally

```
# Example Dockerfile

# use libwebrtc as base image
FROM libwebrtc:<TAG> as builder

# install any dependencies you need
# build your project
# use additional build stages to reduce image size
# profit
```

## Features

- Full `libwebrtc` source code, except `.git` folders, at `$WEBRTC_SRC_DIR` (`/webrtc/src`)
- Built static binaries (release with symbols) at `$WEBRTC_OBJ_DIR` (`/webrtc/out/obj`)
- Based on `debian:buster` for easy additional dependency installation

## Version support

Currently we only build WebRTC release `m84` but other versions can be supported. Please file a PR or issue (noting the branch head e.g. `refs/remotes/branch-heads/4147`) if you need to build a different version.

## Building this image

To build this image, amend the `WEBRTC_CHECKOUT` and `TAG` variables in `build.sh` and run. Easier customization may be supported in the future.

## Pull requests and issues

Accepting pull requests and issues! Please use our repo: https://github.com/treble/libwebrtc-docker

## License

BSD 3-clause. See `LICENSE`.