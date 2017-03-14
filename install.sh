#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================#
#   System Required:  CentOS/RadHat 5+                                          #
#   Description:  Uninstall LAMP(Linux + Nginx + MySQL + PHP )                  #
#   Author: GufengWang <cn.wangbj@icloud.com>                                   #
#   Intro:  https://diycode.me                                                  #
#===============================================================================#
cur_dir=`pwd`

#include lamp module
include(){
    local include=$1
    if [[ -s ${cur_dir}/include/${include}.sh ]];then
        . ${cur_dir}/include/${include}.sh
    else
        echo "Error:${cur_dir}/include/${include}.sh not found, shell can not be executed."
        exit 1
    fi
}

#lamp main process
lamp(){
    include config
    include public
    include nginx
    include php
    include mysql
    include redis
    echo "Game is over!";
    clear
    echo "#####################################################################"
    echo "# Auto Install LAMP(Linux + Nginx + MySQL + PHP )                   #"
    echo "# Intro:  https://diycode.me                                        #"
    echo "# Author: GufengWang <cn.wangbj@icloud.com>                         #"
    echo "#####################################################################"
    rootness
    load_config
    public_install
    lanp_install
    clear_packet
    service php7-fpm start
    cd ${current_dir}
}

#Run it
lamp 2>&1 | tee -a
