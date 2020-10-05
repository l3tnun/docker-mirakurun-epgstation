FROM l3tnun/epgstation:alpine

ENV DEV="autoconf automake bash binutils bzip2 cmake curl coreutils diffutils file g++ gcc gperf libtool make python openssl-dev tar yasm nasm zlib-dev expat-dev pkgconfig libass-dev lame-dev opus-dev libtheora-dev libvorbis-dev libvpx-dev x264-dev x265-dev"
ENV FFMPEG_VERSION=4.1

RUN apk add --no-cache libgcc libstdc++ ca-certificates libcrypto1.1 libssl1.1 libgomp expat git lame libass libvpx opus libtheora libvorbis x264-libs x265-libs $DEV && \
\
#ffmpeg build
\
    mkdir /tmp/ffmpeg_sources && \
    cd /tmp/ffmpeg_sources && \
    wget http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 -O ffmpeg.tar.bz2 && \
    tar xjvf ffmpeg.tar.bz2 && \
    cd /tmp/ffmpeg_sources/ffmpeg* && \
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
      --enable-nonfree \
      --disable-debug \
      --disable-doc \
    && \
    cd /tmp/ffmpeg_sources/ffmpeg* && \
    make -j$(nproc) && \
    make install && \
\
# 不要なパッケージを削除
\
    apk del $DEV && \
    rm -rf /tmp/ffmpeg_sources