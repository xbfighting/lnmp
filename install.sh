#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================#
#   System Required:  CentOS/RadHat 5+                                          #
#   Description:  Uninstall LAMP(Linux + Nginx + MySQL + PHP )                  #
#   Author: GufengWang <cn.wangbj@icloud.com>                                   #
#   Intro:  https://diycode.me                                                  #
#===============================================================================#

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
lanp(){
    include config
    include public
    include php
    include nginx
    include mysql
    include redis
    echo "Game is over!";
    clear
    echo "#####################################################################"
    echo "# Auto Install LAMP(Linux + Nginx + MySQL + PHP )                   #"
    echo "# Intro:  https://diycode.me                                        #"
    echo "# Author: GufengWang <cn.wangbj@icloud.com>                         #"
    echo "#####################################################################"
    load_config
    public_install
    lanp_install

    cd ${current_dir}
}

#Run it
lanp 2>&1 | tee -a
