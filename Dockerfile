FROM alpine:edge
RUN echo "http://dl-5.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
	echo "http://dl-5.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

RUN apk --update add bash docker git
ADD dockpipe.sh /usr/local/bin/dockpipe