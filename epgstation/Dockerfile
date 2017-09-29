FROM debian:stretch
EXPOSE 8888
ARG CPUCORE="1"
ENV DEV="make gcc git g++ automake curl wget autoconf build-essential python2.7 libass-dev libfreetype6-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev"
ENV FFMPEG_VERSION=3.3.4

RUN apt-get update && \
    apt-get -y install $DEV && \
    apt-get -y install yasm libx264-dev libmp3lame-dev libopus-dev && \
    apt-get -y install libasound2 libass5 libvdpau1 libva-x11-1 libva-drm1 libxcb-shm0 libxcb-xfixes0 libxcb-shape0 libvorbisenc2 libtheora0 && \
    apt-get -y install libva1 i965-va-driver && \
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
      --pkg-config-flags=--static \
      --enable-gpl \
      --enable-libass \
      --enable-libfreetype \
      --enable-libmp3lame \
      --enable-libopus \
      --enable-libtheora \
      --enable-libvorbis \
      --enable-libx264 \
      --enable-nonfree \
      --disable-debug \
      --disable-doc \
      --enable-vaapi \
    && \
    cd /tmp/ffmpeg_sources/ffmpeg* && \
    make -j${CPUCORE} && \
    make install && \
\
# nodejs install
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs && \
\
# install EPGStation
    cd /usr/local/ && \
    git clone https://github.com/l3tnun/EPGStation.git && \
    cd /usr/local/EPGStation && \
    npm install && \
    npm run build && \
\
# 不要なパッケージを削除
\
    apt-get -y remove $DEV && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/ffmpeg_sources

WORKDIR /usr/local/EPGStation

ENTRYPOINT npm start

