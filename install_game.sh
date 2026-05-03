#!/bin/bash
source config.sh
export steamuser=''
echo "Install Left4dead2 server (maybe) need to login non-anonymous user. Please Enter Steam acccount username."
read -p"Steam username:" steamuser

if test -z "${steamuser}" ; then
  echo "Login in anonymous user."
  steamuser=anonymous
; fi

mkdir -p ${game_local_path}

chown 1000.1000 ${game_local_path}

docker run --name l4d2_ric_install -it \
-v ${game_local_path}:${game_container_path} \
cm2network/steamcmd \
./steamcmd.sh +force_install_dir ${game_container_path} +login ${steamuser} +app_update 222860 validate +quit


#if test -e "${game_local_path}/left4dead2/addons" ; then
#  docker commit l4d2_ric_install steamcmd_updated:latest
#fi
#docker rm l4d2_ric_install
