# butt-docker

[![Docker](https://github.com/hammady/butt-docker/workflows/Docker/badge.svg)](https://github.com/hammady/butt-docker/actions/workflows/docker-build-push.yml)

[BUTT](http://danielnoethen.de/butt/) (Broadcast Using This Tool) in a Docker container.

## System requirements

Docker (obviously!)

## Development
### Configure

Inspect the file `butt-settings.ini` for default values and those that can be overridden.

One important setting is the audio device id/name. One way to identify this
is to run BUTT on the host (not inside a container), save/export the settings and
inspect the generated id/name. If you cannot run BUTT on the host, you can do trial and error
with the id until you find a correct recording. If there is a better way to do this,
please submit an issue/PR here. 

```ini
dev_remember = 0 # by id
dev_remember = 1 # by name
device = 1 # device id
dev_name = USB Audio Device: - (hw:2,0) [ALSA] # device name
```

Other settings can be passed as environment variables, see the run section below.

### Build

Build using docker. There are 2 arguments to the build command:
- `USER_ID` which forwards the same user id running the command
- `BUTT_VERSION` defaults to 0.1.34, and should match the vendored version

The build process creates a corresponding user matching the uid of the user
that builds (and probably runs with volume mounts) the container so that generated
files belong to the host user.

```bash
docker build . -t butt:0.1.34 \
    --build-arg USER_ID=$UID \
    --build-arg BUTT_VERSION=0.1.34
```

### Run

```bash
docker run -d \
    --restart always \
    --name butt \
    -v $HOME/butt:/data \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --device /dev/snd \
    -p 1256:1256 \
    -e BUTT_TIMEZONE=Canada/Eastern \
    -e BUTT_SERVER_NAME=MyServer \
    -e BUTT_SERVER_TYPE=0 \
    -e BUTT_SERVER_ADDRESS=us2.internet-radio.com \
    -e BUTT_SERVER_PORT=8164 \
    -e BUTT_SERVER_PASSWORD=REDACTED \
    -e BUTT_DEVICE_ID=1 \
    -e BUTT_SAMPLE_RATE=44100 \
    -e BUTT_BITRATE=64 \
    -e BUTT_CHANNELS=1 \
    -e BUTT_CODEC=mp3 \
    -e BUTT_SILENCE_LEVEL=54.000000 \
    -e BUTT_SIGNAL_LEVEL=52.000000 \
    butt:0.1.34
```

The most notable argument above is the first `-v` which mounts a host path inside
the container so that generated logs and recordings are all read/written
to the host. The other mount `-v /tmp/.X11-unix:/tmp/.X11-unix:rw` is also required
for X forwarding to work (to display BUTT on the main display, requires a locally running X server).
You may override the `DISPLAY` environment variable to use a different display.
Note also that `--device /dev/snd` is important as it makes the audio
devices on the host available to the container. This has been tested on Ubuntu Linux.
Windows and macOS hosts are not supported because docker does not run natively on them.
Note that you cannot run BUTT in swarm mode because it doesn't support devices or privileged mode.

Time zones are important for the recordings to be generated with correct file names.
To set the time zone, use the `BUTT_TIMEZONE` environment variable.
For a list of all timezones, see: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
If not set, will default to UTC.

## Production

GitHub actions are configured to build and push a docker image.
Visit [the package page](https://github.com/hammady/butt-docker/pkgs/container/butt)
for more information.