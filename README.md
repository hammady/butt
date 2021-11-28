# butt-docker

[BUTT](http://danielnoethen.de/butt/) (Broadcast Using This Tool) in a Docker container.

## System requirements

Docker (obviously!)

## Configure

Edit the file `butt-settings.ini` or export from another BUTT installation.
The default settings reads stream title, generate logs and create recordings
in `/butt`. You will probably need to mount this container path to the host
(see the `-v` argument below). Make sure the host path exists and contains
a sub-directory: `recordings`, or change it as appropriate.

Another important setting is the audio device id/name. One way to identify this
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

## Build

Build using docker. There are 3 arguments to the build command:
- `USER_ID` which forwards the same user id running the command
- `GROUP_ID` which forwards the first group id for the same user running the command
- `BUTT_VERSION` defaults to 0.1.32, but you can change it to any version

The build process creates a corresponding user matching the uid and gid of the user
that builds (and probably runs with volume mounts) the container so that generated
files belong to the host user.

```bash
docker build . -t butt:0.1.32 \
    --build-arg USER_ID=$UID \
    --build-arg GROUP_ID=${GROUPS[0]} \
    --build-arg BUTT_VERSION=0.1.32
```

## Run

```bash
docker run -d \
    --restart always \
    --name butt \
    --net=host \
    --device /dev/snd \
    -v $HOME/butt:/butt \
    butt:0.1.32
```

The most notable argument above is the `-v` which mounts a host path inside
the container so that generated logs, recordings, stream titles are all read/written
to the host. Note also that `--device /dev/snd` is important as it makes the audio
devices on the host available to the container.