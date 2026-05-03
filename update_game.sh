#!/bin/bash
#export game_local_path=/lib/games/steam/left4dead2
#export game_container_path=/home/steam/left4dead2
source config.sh
export login_user='anonymous'

#mkdir -p ${game_local_path}

chown 1000.1000 ${game_local_path}

docker run -d --rm --name l4d2_ric_update \
-v ${game_local_path}:${game_container_path} \
steamcmd_updated \
./steamcmd.sh +force_install_dir ${game_container_path} +login ${login_user} +app_update 222860 validate +quit
