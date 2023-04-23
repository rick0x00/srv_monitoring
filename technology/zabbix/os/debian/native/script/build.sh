#!/usr/bin/env bash

# ============================================================ #
# Tool Created date: 22 abr 2023                               #
# Tool Created by: Henrique Silva (rick.0x00@gmail.com)        #
# Tool Name: srv_monitoring (ZABBIX)                           #
# Description:  #
# License: MIT License                                         #
# Remote repository 1: https://github.com/rick0x00/srv_monitoring   #
# Remote repository 2: https://gitlab.com/rick0x00/srv_monitoring   #
# ============================================================ #

# ============================================================ #
# start root user checking
if [ $(id -u) -ne 0 ]; then
    echo "Please use root user to run the script."
    exit 1
fi
# end root user checking
# ============================================================ #
# start set variables

zbx_version="6.0"
os_distribution="debian"
os_version=("11" "bullseye")
zbx_component=("server" "frontend" "agent")
database_engine="mysql"
webserver="apache"

port[0]="XPTO" # description
port[1]="bar" # description

workdir="workdir"
persistence_volumes=("persistence_volume_N" "Logs")
expose_ports="${port[0]}/tcp ${port[1]}/udp"
# end set variables
# ============================================================ #
# start definition functions
# ============================== #
# start complement functions

# end complement functions
# ============================== #
# start main functions
function pre_configure_server () {
}

function install_server () {
	pre_configure_server;
}

function configure_server () {
}

function start_server () {
}


function pre_configure_client () {
}

function install_client () {
	pre_configure_client;
}

function configure_client () {
}

function start_client () {
}
# end main functions
# ============================== #
# end definition functions
# ============================================================ #
# start argument reading

# end argument reading
# ============================================================ #
# start main executions of code
install_server;
configure_server;
start_server;

install_client;
configure_client;
start_client;
