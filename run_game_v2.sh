#!/bin/bash
export game_hostname=left4dead2
export game_local_port=27015
export game_local_path=/lib/games/steam/left4dead2
export game_container_path=/home/steam/left4dead2
#export game_cfg_local_path=/lib/games/l4d2_server_file/server.cfg
export game_map=c2m1_highway
export game_cvars="+sv_gametypes coop +hostname ${game_hostname} +exec server.cfg +map ${game_map}"

#test -e ${game_cfg_local_path} || {echo "error var: game_cfg_local_path" >&2 ; exit 1; }

docker run -itd --name l4d2_${game_hostname} \
-p ${game_local_port}:27015/tcp -p ${game_local_port}:27015/udp \
-v ${game_local_path}:${game_container_path} \
cm2network/steamcmd:latest \
${game_container_path}/srcds_run -game left4dead2 -debug -insecure ${game_cvars}

#-v ${game_cfg_local_path}:${game_container_path}/left4dead2/cfg/server.cfg \