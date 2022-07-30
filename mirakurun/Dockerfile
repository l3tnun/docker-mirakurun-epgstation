FROM node:16.16.0-alpine
LABEL maintainer "h-mineta <h-mineta@0nyx.net>"

ENV DOCKER="YES"

RUN set -x \
	&& apk upgrade --update \
	&& apk add \
		bash \
		coreutils \
		libusb \
		pcsc-lite \
		pcsc-lite-libs \
		curl \
		ca-certificates \
		util-linux \
		gzip \
		vim \
		wget \
		curl \
		linux-headers \
		pcsc-lite-dev \
		ccid \
	\
	&& apk add --virtual .build-deps \
		git \
		make \
		gcc \
		g++ \
		gzip \
		autoconf \
		automake \
		libc-dev \
		musl-dev \
		eudev-dev \
		libevent-dev \
		libusb-dev \
		libtool\
		flex\
	\
	# firmware
	&& cd /tmp/ \
	&& wget http://plex-net.co.jp/plex/px-s1ud/PX-S1UD_driver_Ver.1.0.1.zip \
	&& unzip PX-S1UD_driver_Ver.1.0.1.zip \
	&& mkdir -p /usr/local/lib/firmware \
	&& cp PX-S1UD_driver_Ver.1.0.1/x64/amd64/isdbt_rio.inp /usr/local/lib/firmware/ \
	&& cp PX-S1UD_driver_Ver.1.0.1/x64/amd64/isdbt_rio.inp /lib/firmware/ \
	&& mkdir -p /etc/ld.so.conf.d/ \
	&& echo '/usr/local/lib' >> /etc/ld.so.conf.d/local.conf \
	&& echo 'smsusb' >> /etc/modules \
	# other setting
	&& adduser root video \
	# npm
	&& npm install pm2 -g \
	\
	# mirakurun
	&& npm install mirakurun@latest -g --unsafe --production \
	\
	# softcas
	&& cd /tmp/ \
	&& wget http://web.archive.org/web/20140928031051/http://www.wazoku.net/softcas.zip \
	&& unzip softcas.zip \
	&& cd /tmp/softcas \
	&& wget -O winscard.cpp http://pastebin.com/raw/5144Ah9g \
	&& wget -O Makefile http://pastebin.com/raw/FQdSixkB \
	&& sed -i "/LONG SCardGetStatusChange/s/LPSCARD_READERSTATE_A/LPSCARD_READERSTATE/g" winscard.cpp \
	&& sed -i "s/SCARD_IO_REQUEST g_rgSCardT1Pci;/const SCARD_IO_REQUEST g_rgSCardT1Pci = { SCARD_PROTOCOL_T1, sizeof(SCARD_IO_REQUEST) };/g" winscard.cpp \
	&& make \
	&& mv /usr/lib/libpcsclite.so.1.0.0 /usr/lib/libpcsclite.so.1.0.0.backup \
	&& cp libpcsclite.so.1.0.0 /usr/lib/libpcsclite.so.1.0.0 \
	\
	# arib25
	&& cd /tmp/ \
	&& wget http://hg.honeyplanet.jp/pt1/archive/c44e16dbb0e2.zip \
	&& unzip c44e16dbb0e2.zip \
	&& cd /tmp/pt1-c44e16dbb0e2/arib25/src \
	&& make \
	&& make install || echo "kuso" \
	\
	# recdvb
	&& cd /tmp/ \
	&& wget http://www13.plala.or.jp/sat/recdvb/recdvb-1.3.1.tgz \
	&& tar xvzf recdvb-1.3.1.tgz \
	&& cd recdvb-1.3.1 \
	&& ./autogen.sh \
	&& ./configure --enable-b25 \
	&& sed -i '/#include <sys\/msg.h>/d' recpt1core.h \
	&& sed -i -E 's!(#include <sys/msg.h>)!#undef _GNU_SOURCE\n#undef _BSD_SOURCE\n\1!' recpt1.c \
	&& sed -i -E 's!(#include <sys/msg.h>)!#undef _GNU_SOURCE\n#undef _BSD_SOURCE\n\1!' recpt1ctl.c \
	&& sed -i -E 's!(#include <sys/msg.h>)!#undef _GNU_SOURCE\n#undef _BSD_SOURCE\n\1!' checksignal.c \
	&& sed -i -E 's!(#include <ctype.h>)!\1\n#include <event.h>!' tssplitter_lite.c \
	&& sed -i 's#-I../driver#-I../driver -I/usr/local/include#' Makefile \
	&& make \
	&& make install \
	\
	# cleaning
	&& cd / \
	&& npm cache verify \
	&& apk del --purge .build-deps \
        && rm /tmp/softcas.zip \
        && rm -rf /tmp/softcas \
	&& rm -rf /tmp/recpt1 \
	&& rm -rf /tmp/ccid-* \
	&& rm -rf /var/cache/apk/*

	# forward request and error logs to docker log collector
	#&& ln -sf /dev/stdout /usr/local/var/log/mirakurun.stdout-0.log \
	#&& ln -sf /dev/stderr /usr/local/var/log/mirakurun.stderr-0.log

COPY services.sh /usr/local/bin

WORKDIR /usr/local/lib/node_modules/mirakurun
CMD ["/usr/local/bin/services.sh"]
EXPOSE 40772
