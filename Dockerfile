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
RUN adduser --uid $USER_ID --system --home /home/butt butt && \
    usermod -aG audio butt
WORKDIR /home/butt

ARG BUTT_VERSION=0.1.32
ENV BUTT_VERSION=$BUTT_VERSION
COPY butt-$BUTT_VERSION /home/butt/butt-$BUTT_VERSION   
RUN chown -R butt butt-$BUTT_VERSION

USER butt
  
RUN cd butt-$BUTT_VERSION && \
    ./configure --disable-aac --prefix=$PWD && \
    make && \
    make install

COPY butt-settings.ini /home/butt

ENV DISPLAY :0

CMD /home/butt/butt-$BUTT_VERSION/bin/butt -c /home/butt/butt-settings.ini
