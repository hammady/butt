FROM debian:buster
LABEL maintainer "Hossam Hammady <github@hammady.net>"

RUN apt-get update && \
    apt-get install -y \
        build-essential autoconf automake m4 \
        curl \
        libfltk1.3-dev \
        portaudio19-dev \
        libopus-dev \
        libmp3lame-dev \
        libvorbis-dev \
        libogg-dev \
        libflac-dev \
        libdbus-1-dev \
        libsamplerate0-dev \
        libssl-dev

ARG USER_ID=1000
RUN adduser --uid $USER_ID --system --home /home/butt butt && \
    usermod -aG audio butt
WORKDIR /home/butt

COPY butt-settings.ini /home/butt
RUN chown -R butt /home/butt

ARG BUTT_VERSION=0.1.33
ENV BUTT_VERSION=$BUTT_VERSION

USER butt

RUN curl -fSsqL -o butt-$BUTT_VERSION.tar.gz https://sourceforge.net/projects/butt/files/butt/butt-$BUTT_VERSION/butt-$BUTT_VERSION.tar.gz/download && \
    tar -xzf butt-$BUTT_VERSION.tar.gz && \
    rm -f butt-$BUTT_VERSION.tar.gz && \
    cd butt-$BUTT_VERSION && \
    ./configure --disable-aac --prefix=$PWD && \
    make && \
    make install

ENV DISPLAY :0

CMD /home/butt/butt-$BUTT_VERSION/bin/butt -c /home/butt/butt-settings.ini
