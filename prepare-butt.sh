#!/usr/bin/env bash

# Script to replace some settings in the butt-settings before launching butt

envsubst < /home/butt/butt-settings.ini > /home/butt/.buttrc

exec "$@"
