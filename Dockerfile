FROM alpine:3.7
MAINTAINER nickd25


RUN apk update
RUN apk upgrade

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

WORKDIR /opt

EXPOSE 5050
VOLUME /config /downloads /logs /torrents

# root filesystem
#COPY root /

ENTRYPOINT ["python", "CouchPotatoServer/CouchPotato.py"]