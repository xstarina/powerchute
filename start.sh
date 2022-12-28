#!/bin/bash

if (( $EUID != 0 )); then
  sudo "$0"
  exit
fi

DATADIR=/docker/apc

IMG=starina/powerchute:ubuntu-latest
docker pull $IMG

if [ ! -d "$DATADIR/.ssh" ]
then
  mkdir -p "$DATADIR/.ssh"
  chown root:root "$DATADIR/.ssh"
  chmod 700 "$DATADIR/.ssh"
fi
[ ! -d "$DATADIR/cmdfiles" ] && mkdir -p "$DATADIR/cmdfiles"

if [ ! -f "$DATADIR/m11.cfg" ]
then
  IMGID=$(docker create $IMG)
  for F in DataLog EventLog m11.cfg pcbeconfig.ini cmdfiles/default.sh
  do
    [ ! -f "$DATADIR/$F" ] && docker cp $IMGID:/opt/APC/PowerChuteBusinessEdition/Agent/$F "$DATADIR/$F" || touch "$DATADIR/$F"
  done
  docker rm -v $IMGID
fi

# docker stop apc
# docker rm apc

docker run \
  --name apc \
  --network host \
  --device /dev/ttyS0 \
  --env TZ=Europe/Moscow \
  --mount type=bind,source="$DATADIR/DataLog",target=/opt/APC/PowerChuteBusinessEdition/Agent/DataLog \
  --mount type=bind,source="$DATADIR/EventLog",target=/opt/APC/PowerChuteBusinessEdition/Agent/EventLog \
  --mount type=bind,source="$DATADIR/m11.cfg",target=/opt/APC/PowerChuteBusinessEdition/Agent/m11.cfg \
  --mount type=bind,source="$DATADIR/pcbeconfig.ini",target=/opt/APC/PowerChuteBusinessEdition/Agent/pcbeconfig.ini \
  --mount type=bind,source="$DATADIR/.ssh/",target=/root/.ssh/ \
  --mount type=bind,source="$DATADIR/cmdfiles/",target=/opt/APC/PowerChuteBusinessEdition/Agent/cmdfiles/ \
  --restart always \
  --detach $IMG
