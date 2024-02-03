#!/usr/bin/env bash

# ============================================================ #
# Tool Created date: 02 fev 2024                               #
# Tool Created by: Henrique Silva (rick.0x00@gmail.com)        #
# Tool Name: prometheus Install                                #
# Description: My simple script to provision prometheus Server #
# License: software = MIT License                              #
# Remote repository 1: https://github.com/rick0x00/srv_monitoring #
# Remote repository 2: https://gitlab.com/rick0x00/srv_monitoring #
# ============================================================ #
# base content:
#   https://prometheus.io/docs/prometheus/latest/installation/

# ============================================================ #
# start root user checking
if [ $(id -u) -ne 0 ]; then
    echo "Please use root user to run the script."
    exit 1
fi
# end root user checking
# ============================================================ #
# start set variables

os_distribution="Debian"
os_version=("11" "bullseye")

database_engine="undefined"
webserver_engine="undefined"

WEB_PROTOCOL="http"
HTTP_PORT[0]="9090" # http number Port
HTTP_PORT[1]="tcp" # http protocol type

BUILD_PATH="/usr/local/src"
WORKDIR="/etc/prometheus/"
PERSISTENCE_VOLUMES=("/etc/prometheus/" "/var/log/")
EXPOSE_PORTS="${HTTP_PORT[0]}/${HTTP_PORT[1]}}"
# end set variables
# ============================================================ #
# start definition functions
# ============================== #
# start complement functions

function remove_space_from_beginning_of_line {
    #correct execution
    #remove_space_from_beginning_of_line "<number of spaces>" "<file to remove spaces>"

    # Remove a white apace from beginning of line
    #sed -i 's/^[[:space:]]\+//' "$1"
    #sed -i 's/^[[:blank:]]\+//' "$1"
    #sed -i 's/^ \+//' "$1"

    # check if 2 arguments exist
    if [ $# -eq 2 ]; then
        #echo "correct quantity of args"
        local spaces="${1}"
        local file="${2}"
    else
        #echo "incorrect quantity of args"
        local spaces="4"
        local file="${1}"
    fi
    sed -i "s/^[[:space:]]\{${spaces}\}//" "${file}"
}

function messenger_a() {
    line_divisor="###########################################################################################"
    echo "${line_divisor}"
    echo "########## $* "
    echo "${line_divisor}"
}

function messenger_b() {
    line_divisor="==================================================================================="
    echo "${line_divisor}"
    echo "######## $*"
    echo "${line_divisor}"
}

function messenger_c() {
    line_divisor="+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "${line_divisor}"
    echo "###### $*"
    echo "${line_divisor}"
}

function messenger_d() {
    line_divisor="-------------------------------------------------------------------"
    echo "${line_divisor}"
    echo "#### $*"
    echo "${line_divisor}"
}

function messenger_e() {
    line_divisor="..........................................................."
    echo "${line_divisor}"
    echo "## $*"
    echo "${line_divisor}"
}

# end complement functions
# ============================== #
# start main functions
##########################################################

function pre_install_server () {
    messenger_b "Pre install server step"

    function install_generic_tools() {
        messenger_c "Install Generic Tools"

        # update repository
        apt update

        #### start generic tools
        # install basic network tools
        apt install -y iputils-ping net-tools iproute2 traceroute mtr
        # install advanced network tools
        apt install -y tcpdump nmap netcat
        # install DNS tools
        apt install -y dnsutils
        # install process inspector
        apt install -y procps htop psmisc
        # install text editors
        apt install -y nano vim
        # install web-content downloader tools
        apt install -y wget curl
        # install uncompression tools
        apt install -y unzip tar
        # install file explorer with CLI
        apt install -y mc
        # install task scheduler
        apt install -y cron
        # install log register
        apt install -y rsyslog
        #### stop generic tools
    }

    install_generic_tools
}

##########################################################
## install steps

function install_prometheus () {
    # installing prometheus
    messenger_c "Installing prometheus"

    function install_dependencies () {
        # install dependencies from project
        messenger_d "Installing Dependencies"
        echo "this step is not configured"
    }

    function install_from_source () {
        # Installing from Source
        messenger_d "Installing from Source"
        echo "this step is not configured"       
    }

    function install_from_apt () {
        # Installing from APT
        messenger_d " Installing from APT"
        
        apt install -y prometheus prometheus-alertmanager prometheus-node-exporter
    }

    function install_complements () {
        messenger_d " Installing Complements"
        #apt install -y ...
    }

    #install_dependencies

    ## Installing prometheus From Source ##
    #install_from_source

    ## Installing prometheus From APT (Debian package manager) ##
    install_from_apt

    #install_complements;

}

function install_supervisor () {
    # installing supervisor
    messenger_c "Installing supervisor"

    function install_dependencies () {
        # install dependencies from project
        messenger_d "Installing Dependencies"
        echo "this step is not configured"
        #apt install -y ...
    }

    function install_from_source () {
        # Installing from Source
        messenger_d "Installing from Source"
        echo "this step is not configured"
    }

    function install_from_apt () {
        # Installing from APT
        messenger_d " Installing from APT"
        apt install -y supervisor
    }

    function install_complements () {
        messenger_d " Installing Complements"
        echo "this step is not configured"
        #apt install -y ...
    }

    #install_dependencies

    ## Installing supervisor From Source ##
    #install_from_source

    ## Installing supervisor From APT (Debian package manager) ##
    install_from_apt

    #install_complements;

}

#############################

function install_server () {
    messenger_b "Install server step"

    ##  prometheus
    install_prometheus
    ##  supervisor
    install_supervisor
}

##########################################################
## start/stop steps ##

function start_prometheus () {
    # starting prometheus
    messenger_c "Starting prometheus"

    #### service: prometheus(main)
    #service prometheus start
    #systemctl start prometheus
    /etc/init.d/prometheus start    

    # Daemon running on foreground mode
    #/usr/bin/prometheus --storage.tsdb.retention.time=5y


    #### service: prometheus-alertmanager(complement)
    #service prometheus-alertmanager start
    #systemctl start prometheus-alertmanager
    /etc/init.d/prometheus-alertmanager start    

    # Daemon running on foreground mode
    #/usr/bin/prometheus-alertmanager


    #### service: prometheus-node-exporter(complement)
    #service prometheus-node-exporter start
    #systemctl start prometheus-node-exporter
    /etc/init.d/prometheus-node-exporter start    

    # Daemon running on foreground mode
    #/usr/bin/prometheus-node-exporter
}

function stop_prometheus () {
    # stopping prometheus
    messenger_c "Stopping prometheus"

    #### service: prometheus(main)
    #service prometheus stop
    #systemctl stop prometheus
    /etc/init.d/prometheus stop    

    # ensuring it will be stopped
    killall prometheus


    #### service: prometheus-alertmanager(complement)
    #service prometheus-alertmanager stop
    #systemctl stop prometheus-alertmanager
    /etc/init.d/prometheus-alertmanager stop    

    # ensuring it will be stopped
    killall prometheus-alertmanager


    #### service: prometheus-node-exporter(complement)
    #service prometheus-node-exporter stop
    #systemctl stop prometheus-node-exporter
    /etc/init.d/prometheus-node-exporter stop    

    # ensuring it will be stopped
    killall prometheus-node-exporter
}

function enable_prometheus () {
    # Enabling prometheus
    messenger_c "Enabling prometheus"

    systemctl enable prometheus
    systemctl enable prometheus-alertmanager
    systemctl enable prometheus-node-exporter
}

function disable_prometheus () {
    # Disabling prometheus
    messenger_c "Disabling prometheus"

    systemctl disable prometheus
    systemctl disable prometheus-alertmanager
    systemctl disable prometheus-node-exporter
}

##############

function start_supervisor () {
    # starting supervisor
    messenger_c "Starting supervisor"

    #service supervisor start
    #systemctl start supervisor
    /etc/init.d/supervisor start

    # Daemon running on foreground mode
    #/usr/bin/python3 /usr/bin/supervisord -c /etc/supervisor/supervisord.conf -n
}

function stop_supervisor () {
    # stopping supervisor
    messenger_c "Stopping supervisor"

    #service supervisor stop
    #systemctl stop supervisor
    /etc/init.d/supervisor stop

    # ensuring it will be stopped
    # for Daemon running on foreground mode
    killall supervisor
}

function enable_supervisor () {
    # Enabling supervisor
    messenger_c "Enabling supervisor"

    systemctl enable supervisor
}

function disable_supervisor () {
    # Disabling supervisor
    messenger_c "Disabling supervisor"

    systemctl disable supervisor
}

#############################

function start_server () {
    messenger_b "Starting server step"
    # Starting Service

    # starting prometheus
    start_prometheus
    start_supervisor
}

function stop_server () {
    messenger_b "Stopping server step"

    # stopping server
    stop_prometheus
    stop_supervisor
}

function enable_server () {
    messenger_b "Enable server step"

    # enabling server
    enable_prometheus
    enable_supervisor
}

function disable_server () {
    messenger_b "Disabling server step"

    # stopping server
    disable_prometheus
    disable_supervisor
}

##########################################################
## configuration steps ##

function configure_prometheus() {
    # Configuring prometheus
    messenger_c "Configuring prometheus"

    local date_info="$(date +"Y%Ym%md%d-H%HM%MS%S")"
    local config_file="/etc/prometheus/prometheus.yml"
    local backup_file="${config_file}.bkp-${date_info}"
    messenger_e "making backup file ${backup_file}"
    cp ${config_file} ${backup_file}


    function configure_prometheus_security() {
        # Configuring prometheus Security
        messenger_d "Configuring prometheus Security"
        echo "this step is not configured"
    }

    function configure_prometheus_configs() {
        # Configuring prometheus
        messenger_d "Configuring prometheus configs"
        echo "this step is not configured"
    }

    # configuring security on prometheus
    configure_prometheus_security

    # setting prometheus site
    configure_prometheus_configs
}

function configure_supervisor() {
    # Configuring supervisor
    messenger_c "Configuring Supervisor"

    local daemon_name="$1"
    local daemon_command="$2"

    local supervisor_program_managed_name="${daemon_name:-prometheus}"
    local supervisor_program_managed_execution_command="${daemon_command:-${PROMETHEUS_DAEMON_FOREGROUND_EXECUTION_COMMAND}}"
    local supervisor_config_path="/etc/supervisor/conf.d/"
    local supervisor_config_file="${supervisor_config_path}${supervisor_program_managed_name}.conf"

    echo "
    [program:${supervisor_program_managed_name}]
    command=bash -c '"${supervisor_program_managed_execution_command}"'
    autostart=true  
    autorestart=true
    startsecs=2
    startretries=10
    stderr_logfile=/var/log/supervisor/%(program_name)s.stderr.log
    stdout_logfile=/var/log/supervisor/%(program_name)s.stdout.log
    redirect_stderr=true
    redirect_stdout=true
    " > ${supervisor_config_file}

    remove_space_from_beginning_of_line "4" "${supervisor_config_file}"
}

#############################

function configure_server () {
    # configure server
    messenger_b "Configure server"

    # configure prometheus
    configure_prometheus

    # configure supervisor
    configure_supervisor "prometheus" "/usr/bin/prometheus --storage.tsdb.retention.time=5y"
    configure_supervisor "prometheus-alertmanager" "/usr/bin/prometheus-alertmanager"
    configure_supervisor "prometheus-node-exporter" "/usr/bin/prometheus-node-exporter"

}

##########################################################
## check steps ##

function check_configs_prometheus() {
    # Check config of prometheus
    messenger_c "Check config of prometheus"

    promtool check config /etc/prometheus/prometheus.yml
}

function check_configs_supervisor() {
    # Check config of supervisor
    messenger_c "Check config of supervisor"
    echo "# supervisor not support config test command"
    #supervisor configtest
}

#############################

function check_configs () {
    messenger_b "Check Configs server"

    # check if the configuration file is ok.
    check_configs_prometheus
    check_configs_supervisor

}

##########################################################
## test steps ##

function test_prometheus () {
    # Testing prometheus
    messenger_c "Testing of prometheus"


    # is running ????
    #service prometheus status
    #systemctl status --no-pager -l prometheus
    /etc/init.d/prometheus status
    ps -ef --forest | grep prometheus

    # is listening ?
    ss -pultan | grep :${HTTP_PORT[0]}

    # is creating logs ????
    tail /var/log/prometheus/*

    # Validating...

    ## scanning prometheus ports using NETCAT
    nc -zv localhost ${HTTP_PORT[0]}
    #root@prometheus:~# nc -zv localhost 9090
    #Connection to localhost (::1) 9090 port [tcp/*] succeeded!


    ## scanning prometheus ports using NMAP
    nmap -A localhost -sT -p ${HTTP_PORT[0]}
    #root@prometheus:/etc/prometheus# nc -zv localhost 9090
    #Connection to localhost (::1) 9090 port [tcp/*] succeeded!
    #root@prometheus:/etc/prometheus# nmap -A localhost -sT -p 9090
    #Starting Nmap 7.80 ( https://nmap.org ) at 2024-02-03 02:01 UTC
    #Nmap scan report for localhost (127.0.0.1)
    #Host is up (0.000094s latency).
    #Other addresses for localhost (not scanned): ::1
    #
    #PORT     STATE SERVICE VERSION
    #9090/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
    #| http-title: Prometheus Time Series Collection and Processing Server
    #|_Requested resource was /classic/graph
    #Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
    #Device type: general purpose
    #Running: Linux 2.6.X
    #OS CPE: cpe:/o:linux:linux_kernel:2.6.32
    #OS details: Linux 2.6.32
    #Network Distance: 0 hops
    #
    #OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
    #Nmap done: 1 IP address (1 host up) scanned in 88.48 seconds


    # specific tool of commands to test
    curl --head http://localhost:${HTTP_PORT[0]}
    #root@prometheus:/etc/prometheus# curl --head http://localhost:9090
    #HTTP/1.1 405 Method Not Allowed
    #Allow: GET, OPTIONS
    #Content-Type: text/plain; charset=utf-8
    #X-Content-Type-Options: nosniff
    #Date: Sat, 03 Feb 2024 02:05:21 GMT
    #Content-Length: 19
    #
    #root@prometheus:/etc/prometheus# curl http://localhost:9090
    #<a href="/classic/graph">Found</a>.
    #

}

function test_supervisor () {
    # Testing supervisor
    messenger_c "Testing of supervisor"


    # is running ????
    #service supervisor status
    #systemctl status  --no-pager -l supervisor
    /etc/init.d/supervisor status
    ps -ef --forest | grep supervisor

    # is listening ?
    #ss -pultan | grep :${port_supervisor[0]}

    # is creating logs ????
    tail /var/log/supervisor/*

    # Validating...

    # specific tool of commands to test
    supervisorctl reread
}


#############################

function test_server () {
    messenger_b "Testing server"

    # testing prometheus
    test_prometheus

    # testing supervisor
    test_supervisor
}

##########################################################

# end main functions
# ============================== #

# end definition functions
# ============================================================ #
# start argument reading

# end argument reading
# ============================================================ #
# start main executions of code
messenger_a "Starting prometheus installation script"
pre_install_server;
install_server;
stop_server;
disable_server;
configure_server;
check_configs;
##start_server;
start_supervisor;
##enable_server;
enable_supervisor;
test_server;
messenger_a "Finished prometheus installation script"


