#!/bin/bash
export game_lcoal_path=/lib/games/steam/left4dead2
export game_container_path=/home/steam/left4dead2

mkdir -p ${game_lcoal_path}

chown 1000.1000 ${game_lcoal_path}

docker run --name install_l4d2 --rm -it \
-v ${game_lcoal_path}:${game_container_path} \
cm2network/steamcmd \
./steamcmd.sh +force_install_dir ${game_container_path} +login anonymous +app_update 222860 validate +quit