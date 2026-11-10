# syntax=docker/dockerfile:1

# Build Butterscotch with the Downwell --gui-ratio patch and the
# Start + Select quit hotkey for ARMv7 (RG35XX / MiaUI).
#
# Usage (recommended, writes ./out/butterscotch):
#   docker build --output type=local,dest=./out .
#
# Or build an image and copy the binary out:
#   docker build -t downwell-butterscotch .
#   docker create --name dw downwell-butterscotch
#   docker cp dw:/butterscotch ./butterscotch
#   docker rm dw
#
# The upstream commit is pinned so the included patch applies cleanly.
# Override it with:
#   docker build --build-arg BUTTERSCOTCH_COMMIT=<sha> ...

FROM debian:bookworm-slim AS build

ARG BUTTERSCOTCH_REPO=https://github.com/ButterscotchRunner/Butterscotch.git
ARG BUTTERSCOTCH_COMMIT=ec4fc0b

RUN dpkg --add-architecture armhf \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      cmake \
      git \
      pkg-config \
      gcc-arm-linux-gnueabihf \
      g++-arm-linux-gnueabihf \
      libsdl2-dev:armhf \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /src

RUN git clone "$BUTTERSCOTCH_REPO" Butterscotch \
 && cd Butterscotch \
 && git checkout "$BUTTERSCOTCH_COMMIT"

COPY downwell-gui-ratio.patch /src/downwell-gui-ratio.patch
COPY start-select-quit.patch /src/start-select-quit.patch
RUN cd /src/Butterscotch \
 && git apply /src/downwell-gui-ratio.patch \
 && git apply /src/start-select-quit.patch

COPY armhf-toolchain.cmake /src/armhf-toolchain.cmake

RUN cd /src/Butterscotch \
 && PKG_CONFIG_LIBDIR=/usr/lib/arm-linux-gnueabihf/pkgconfig \
    cmake -S . -B build-armhf \
      -DCMAKE_TOOLCHAIN_FILE=/src/armhf-toolchain.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DBACKEND=sdl2 \
      -DPLATFORM=cli \
      -DVIDEO_BACKEND=none \
      -DENABLE_FILE_PICKER=OFF \
      -DENABLE_WAD14=OFF \
      -DENABLE_WAD16=OFF \
      -DENABLE_WAD17=ON \
 && cmake --build build-armhf -j"$(nproc)" \
 && arm-linux-gnueabihf-strip build-armhf/butterscotch

# Export stage: `docker build --output type=local,dest=./out .` writes ./out/butterscotch
FROM scratch AS output
COPY --from=build /src/Butterscotch/build-armhf/butterscotch /butterscotch
