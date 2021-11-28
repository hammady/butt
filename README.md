# butt-docker

[BUTT](http://danielnoethen.de/butt/) (Broadcast Using This Tool) in a Docker container.

## System requirements

Docker (obviously!)

## Configure

Edit the file `butt-settings.ini` or export from another BUTT installation.

For the sound device:

mount stream-title and recordings, log file ... etc

## Build

```bash
docker build . -t butt:0.1.32 \
    --build-arg USER_ID=$UID \
    --build-arg GROUP_ID=${GROUPS[0]} \
    --build-arg BUTT_VERSION=0.1.32
```

## Run

```bash
docker run -d --restart always --name butt --net=host butt:0.1.32
```
