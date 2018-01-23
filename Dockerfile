FROM alpine:3.7
MAINTAINER nickd25


RUN apk update
RUN apk upgrade

ARG Puid="911"
ARG Pgid="911"

ENV PGID=$Pgid
ENV PUID=$Puid


# s6 overlay
RUN \
	echo "Install the s6 overlay" && \
	apk add --no-cache ca-certificates wget bash \
	&& wget https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.2/s6-overlay-amd64.tar.gz -O /tmp/s6-overlay.tar.gz \
	&& tar xvfz /tmp/s6-overlay.tar.gz -C / \
	&& rm -f /tmp/s6-overlay.tar.gz 


RUN \
	echo "Build dependencies" && \
	apk add --no-cache \
		git \
		python \
		openssl \
		bash \
		coreutils \
		shadow

RUN mkdir /opt && \
  cd /opt && \
  git clone https://github.com/CouchPotato/CouchPotatoServer.git

RUN \
	echo "Clean up clean up everybody do your share." && \
	rm -rf /root/.cache

RUN groupmod -g 1000 users
RUN useradd -u 911 -U -d /config -s /bin/false abc 
RUN usermod -G users abc

EXPOSE 5050
VOLUME /config /downloads

# root filesystem
COPY root /

ENTRYPOINT [ "/init" ]