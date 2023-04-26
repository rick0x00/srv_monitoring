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

zbx_db_host="localhost"
zbx_db_name="zabbix"
zbx_db_user="zabbix"
zbx_db_pass="zabbix"

root_db_user="root"
root_db_pass="root"


zbx_version="6.0"
os_distribution="debian"
os_version=("11" "bullseye")
zbx_component=("server" "frontend" "agent")
database_engine="mysql"
webserver_engine="apache"

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
function pre_install_zbx () {
    wget https://repo.zabbix.com/zabbix/6.0/debian/pool/main/z/zabbix-release/zabbix-release_6.0-4+debian11_all.deb -O zabbix-repo.deb
    dpkg -i zabbix-repo.deb
}

function install_zbx_server () {
	apt update
    apt install -y zabbix-sql-scripts
    apt install -y zabbix-server-mysql # mysql
}

function install_zbx_frontend () {
	apt update
    apt install -y zabbix-frontend-php 
    apt install -y zabbix-apache-conf # apache
}

function install_zbx_agent () {
	apt update
    apt install -y zabbix-agent
}

function install_webserver () {
    apt install -y apache2
}

function install_database () {
    apt install -y mariadb-client mariadb-server # mariadb
}

function install_server () {
    pre_install_zbx
    install_zbx_server
    install_zbx_frontend
    install_zbx_agent
    install_webserver
    install_database
}

function create_initial_database () {
    #mysql -uroot -p
    mysql -e "SET PASSWORD FOR '$root_db_user'@localhost = PASSWORD('$root_db_pass');"
    mysql -e "ALTER USER '$root_db_user'@'localhost' IDENTIFIED BY '$root_db_pass';"
    mysql -h $zbx_db_host -u"$root_db_user" -p"$root_db_pass" -e "create user ${zbx_db_user}@localhost identified by '$zbx_db_pass';"
    mysql -h $zbx_db_host -u"$root_db_user" -p"$root_db_pass" -e "create database $zbx_db_name character set utf8mb4 collate utf8mb4_bin;"
    mysql -h $zbx_db_host -u"$root_db_user" -p"$root_db_pass" -e "grant all privileges on $zbx_db_name.* to ${zbx_db_user}@localhost;"
    mysql -h $zbx_db_host -u"$root_db_user" -p"$root_db_pass" -e "FLUSH PRIVILEGES;"

    # initial populate the database
    zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql -h $zbx_db_host --default-character-set=utf8mb4 -uzabbix -p"$zbx_db_pass" zabbix
}

function configure_zbx_server () {
    cp /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.bkp
    mv /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.new    
    sed -i "s/# DBPassword=/DBPassword=$zbx_db_pass/" /etc/zabbix/zabbix_server.conf.new
    mv /etc/zabbix/zabbix_server.conf.new /etc/zabbix/zabbix_server.conf
}

function configure_apache_default_page () {
    cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bkp_$(date +%s)
    sed -i "/DocumentRoot/s/var\/www\/html/usr\/share\/zabbix/" /etc/apache2/sites-available/000-default.conf
}

function configure_apache_directory_listing () {
    cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf.bkp_$(date +%s)
    sed -i "/Options/s/Indexes FollowSymLinks/FollowSymLinks/" /etc/apache2/apache2.conf
}

function configure_apache_server_banner () {
    cp /etc/apache2/conf-enabled/security.conf /etc/apache2/conf-enabled/security.conf.bkp_$(date +%s)
    sed -i "/ServerTokens/s/OS/Prod/" /etc/apache2/conf-enabled/security.conf
    sed -i "/ServerSignature/s/On/Off/" /etc/apache2/conf-enabled/security.conf
}

function configure_apache () {
    configure_apache_default_page;
    configure_apache_directory_listing;
    configure_apache_server_banner;
}

function configure_server () {
    create_initial_database;
    configure_zbx_server;
    configure_apache;
}

function start_server () {
    systemctl enable --now zabbix-server
    systemctl enable --now zabbix-agent
    systemctl enable --now mariadb
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

