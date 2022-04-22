FROM debian:buster
LABEL maintainer "Hossam Hammady <github@hammady.net>"

RUN apt-get update && \
    apt-get install -y \
        build-essential wget

ARG BUTT_VERSION=0.1.34
ENV BUTT_VERSION=$BUTT_VERSION

RUN wget -O butt-$BUTT_VERSION.tar.gz https://sourceforge.net/projects/butt/files/butt/butt-$BUTT_VERSION/butt-$BUTT_VERSION.tar.gz/download && \
    tar -xzf butt-$BUTT_VERSION.tar.gz && \
    rm -f butt-$BUTT_VERSION.tar.gz && \
    cd butt-$BUTT_VERSION && \
    ./configure --without-butt --with-client && \
    make && \
    make install

ENTRYPOINT [ "/usr/local/bin/butt-client" ]
