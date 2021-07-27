FROM l3tnun/epgstation:alpine

ENV DEV="autoconf automake bash binutils bzip2 cmake curl coreutils diffutils file g++ gcc gperf libtool make python3 openssl-dev tar yasm nasm zlib-dev expat-dev pkgconfig libass-dev lame-dev opus-dev libtheora-dev libvorbis-dev libvpx-dev x264-dev x265-dev libva-dev"
ENV FFMPEG_VERSION=4.2.4
# intel環境でハードウェアエンコードを利用したい場合は下記をコメントアウト
# ENV LD_LIBRARY_PATH=/opt/intel/mediasdk/lib64
# ENV PKG_CONFIG_PATH=/opt/intel/mediasdk/lib64/pkgconfig

RUN apk add --no-cache libgcc libstdc++ ca-certificates libcrypto1.1 libssl1.1 libgomp expat git lame libass libvpx opus libtheora libvorbis x264-libs x265-libs libva $DEV && \
# aribb24
    mkdir /tmp/aribb24 && cd /tmp/aribb24 && \
    curl -fsSL https://github.com/nkoriyama/aribb24/tarball/master | tar -xz --strip-components=1 && \
    autoreconf -fiv && ./configure && make -j$(nproc) && make install && \
\
# Intel-Media-SDK(for hardware acceleration)
#     mkdir /tmp/libmfx && cd /tmp/libmfx && \
#     curl -fsSL https://github.com/Intel-Media-SDK/MediaSDK/tarball/master | tar -xz --strip-components=1 && \
#     mkdir build && cd build && \
#     cmake -DCMAKE_BUILD_TYPE=MinSizeRel .. && make -j$(nproc) && make install && \
\
#ffmpeg build
    mkdir /tmp/ffmpeg_sources && cd /tmp/ffmpeg_sources && \
    curl -fsSL http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | tar -xj --strip-components=1 && \
    ./configure \
      --prefix=/usr/local \
      --disable-shared \
      --enable-gpl \
      --enable-libass \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libvpx \
      --enable-libx264 \
      --enable-libx265 \
      --enable-version3 \
      --enable-libaribb24 \
#      --enable-libmfx \
      --enable-nonfree \
      --disable-debug \
      --disable-doc \
    && \
    make -j$(nproc) && \
    make install && \
\
# 不要なパッケージを削除
    apk del $DEV && \
    rm -rf /tmp/*
