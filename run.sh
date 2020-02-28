#! /usr//bin/env bash

set -e

if [ ! -d "${1}" ] ; then
    echo usage ./run.sh path-to-unity-project
    exit 1
fi

export HOST_DIR=$(dirname ${0})
export HOST_HOME=${HOST_DIR}/.home
export HOST_USER=$(id -un | tr -d '\n')
export HOST_UID=$(id -u | tr -d '\n')
export HOST_GID=$(id -g | tr -d '\n')

docker build . -t unity3d \
       --build-arg HOST_USER=${HOST_USER} \
       --build-arg HOST_UID=${HOST_UID} \
       --build-arg HOST_GID=${HOST_GID}

mkdir -p ${HOST_HOME}

cp -f ${HOST_DIR}/.bashrc ${HOST_HOME}/

docker run -ti --rm \
     --gpus all,capabilities=graphics \
     --net=host \
     --env="DISPLAY" \
     -v /dev/bus/usb:/dev/bus/usb \
     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
     -v ~/.Xauthority:/home/${HOST_USER}/.Xauthority:rw \
     -v $(realpath ${HOST_HOME}):/home/${HOST_USER} \
     -v /dev/snd:/dev/snd:rw \
     -v /dev/dri:/dev/dri:rw \
     -v $(realpath ${1}):/home/$(basename ${1}) \
     unity3d bash
