FROM debian:buster
LABEL maintainer "Hossam Hammady <github@hammady.net>"

RUN apt-get update && \
    apt-get install -y \
        build-essential autoconf automake m4 \
        wget \
        libfltk1.3-dev \
        portaudio19-dev \
        libopus-dev \
        libmp3lame-dev \
        libvorbis-dev \
        libogg-dev \
        libflac-dev \
        libdbus-1-dev \
        libsamplerate0-dev \
        libssl-dev \
        gettext

ARG USER_ID=1000
RUN adduser --uid $USER_ID --system --home /home/butt butt && \
    usermod -aG audio,root butt && \
    chmod g+w /etc
WORKDIR /home/butt

ARG BUTT_VERSION=0.1.34
ENV BUTT_VERSION=$BUTT_VERSION

RUN wget -O butt-$BUTT_VERSION.tar.gz https://sourceforge.net/projects/butt/files/butt/butt-$BUTT_VERSION/butt-$BUTT_VERSION.tar.gz/download && \
    tar -xzf butt-$BUTT_VERSION.tar.gz && \
    rm -f butt-$BUTT_VERSION.tar.gz && \
    cd butt-$BUTT_VERSION && \
    ./configure --with-client --disable-aac && \
    make && \
    make install

COPY prepare-butt.sh /home/butt
COPY butt-settings.ini /home/butt

RUN chown -R butt /home/butt

USER butt
VOLUME [ "/data" ]
ENV DISPLAY :0
EXPOSE 1256

ENTRYPOINT [ "/home/butt/prepare-butt.sh" ]
CMD [ "/usr/local/bin/butt", "-A", "-p", "1256" ]
