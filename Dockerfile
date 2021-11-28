FROM debian:buster
LABEL maintainer "Hossam Hammady <github@hammady.net>"

RUN apt-get update && \
    apt-get install -y \
        build-essential \
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
ARG GROUP_ID=1000
RUN addgroup --gid $GROUP_ID butt && \
    adduser --uid $USER_ID --gid $GROUP_ID --system --home /home/butt butt
WORKDIR /home/butt
USER butt

ARG BUTT_VERSION=0.1.32
RUN curl -o butt.tgz https://netactuate.dl.sourceforge.net/project/butt/butt/butt-$BUTT_VERSION/butt-$BUTT_VERSION.tar.gz && \
    tar xf butt.tgz && \
    rm butt.tgz && \
    cd butt-$BUTT_VERSION && \
    ./configure --disable-aac --prefix=$PWD && \
    make && \
    make install

COPY butt-settings.ini /home/butt

ENV DISPLAY :0

CMD /home/butt/butt-0.1.32/bin/butt -c /home/butt/butt-settings.ini
