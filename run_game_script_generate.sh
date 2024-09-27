#!/bin/bash
export execute_mode=true
export script_path=$(mktemp -u /tmp/run_l4d2_XXXX.sh)
export container_name=
export game_local_port=
export game_local_path=/lib/games/steam/left4dead2
export game_container_path=/home/steam/left4dead2
export game_cfg_local_path=
export addons_dirs=""
#export game_map=c2m1_highway
#export game_hostname=left4dead2
#export game_cvars="+sv_gametypes coop +hostname ${game_hostname} +exec server.cfg +map ${game_map}"
export game_cvars="+sv_gametypes coop +hostname left4dead2 +exec server.cfg +map c2m1_highway"

function container_container_name {
    if test -z "${container_name}" ; then
        hostname=l4d2 ; else hostname=${container_name}
    fi
    if test $(docker ps -a --format {{.Names}} | grep ^${hostname}$) ; then
        echo "container_container_name: The container \"${hostname}\" already exists. " >&2 ; exit 1
    fi
    echo "--name ${hostname}" '\'
}

function container_port {
    if test -n "${game_local_port}" ; then
        if [ ${game_local_port} -gt 1023 -a ${game_local_port} -lt 65536 ] ; then
            gport=${game_local_port}
        else
            gport=27015
            echo "container_port: Port range in 1024-65535. Now use the default of 27015." >&2
        fi
    else
        gport=27015
    fi
    echo "-p ${gport}:27015/tcp" '\'
    echo "-p ${gport}:27015/udp" '\'
}

function container_game_mount {
    if test ! -d "${game_local_path}" ; then
        echo "The variable game_local_path unavailable." >&2 ; exit 1
    fi
    if test -z "${game_container_path}" ; then
        echo "The variable game_container_path is not set." >&2 ; exit 1
    fi
    echo "-v ${game_local_path}:${game_container_path}" '\'
}

function container_cfg_mount {
    if test -z "${game_cfg_local_path}" ; then return 0 ; fi
    if test ! -f "${game_cfg_local_path}" ; then
        echo 'The variable game_cfg_local_path unavailable' >&2 ; exit 1
    fi
    if test -z "${game_container_path}" ; then
        echo 'The variable game_container_path is not set.' >&2 ; exit 1
    fi
    echo "-v ${game_cfg_local_path}:${game_container_path}/left4dead2/cfg/server.cfg" '\'
}

function container_addons_mount {
    if test -z "${addons_dirs}" ; then return 0 ; fi
    for DIR in ${addons_dirs} ; do {
        if ! test -d ${DIR} ; then
            echo "The path ${DIR} is not a available directory path." >&2 ; exit 1
        fi
        for FILE in $(find ${DIR} -type f) ; do {
            if echo ${FILE} | grep 'left4dead2/' &> /dev/null ; then
                container_file=$(echo ${FILE} | sed -r 's@.+(left4dead2/.+)@\1@')
                echo "-v ${FILE}:${game_container_path}/${container_file}:ro" '\'
            fi
        } done
    } done
}

function game_start {
    echo "${game_container_path}/srcds_run -game left4dead2 -insecure" '\'
    echo "${game_cvars}"
}

function generate_script {
echo "docker run -itd" '\'
container_container_name
container_port
container_game_mount
container_cfg_mount
container_addons_mount
echo "cm2network/steamcmd:latest" '\'
game_start
}


if test "${execute_mode}" == "true" ; then
    while test -f ${script_path} ; do
        script_path=$(mktemp -u /tmp/run_l4d2_XXXX.sh)
    done
    echo "${script_path}"
    generate_script ${script_path} && bash ${script_path}
    echo "done."
else
    generate_script
fi