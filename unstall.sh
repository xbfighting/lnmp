#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#===============================================================================#
#   System Required:  CentOS/RadHat 5+                                          #
#   Description:  Uninstall LAMP(Linux + Nginx + MySQL + PHP )                  #
#   Author: Teddysun <cn.wangbj@icloud.com>                                     #
#   Intro:  https://diycode.me                                                  #
#===============================================================================#

#to Lowcase
upcase_to_lowcase(){
    words=$1
    echo $words | tr '[A-Z]' '[a-z]'
}

#chk System
check_sys(){
    local checkType=$1
    local value=$2
    local release=''
    local systemPackage=''
    if [[ -f /etc/redhat-release ]];then
        release="centos"
        systemPackage="yum"
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
        release="centos"
        systemPackage="yum"
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
        release="centos"
        systemPackage="yum"
    fi
    if [[ ${checkType} == "sysRelease" ]]; then
        if [ "$value" == "$release" ];then
            return 0
        else
            return 1
        fi
    elif [[ ${checkType} == "packageManager" ]]; then
        if [ "$value" == "$systemPackage" ];then
            return 0
        else
            return 1
        fi
    fi
}

#delete Config
boot_stop(){
    if check_sys packageManager apt;then
        update-rc.d -f $1 remove
    elif check_sys packageManager yum;then
        chkconfig --del $1
    fi
    if [ $1 = "php7-fpm" ]; then
        pkill -9 php
    else
        pkill $1
    fi
}

#unstall Soft
uninstall(){
    echo ""
    echo "uninstalling Mysqld Sucess"
    [ -f /etc/init.d/mysqld ] && /etc/init.d/mysqld stop && boot_stop mysqld
    rm -f /etc/init.d/mysqld
    rm -rf /usr/local/mysql /usr/bin/mysqldump /usr/bin/mysql /etc/my.cnf /etc/ld.so.conf.d/mysql.conf
    echo ""
    echo "uninstalling Nginx Sucess"
    [ -f /etc/init.d/nginx ] && /etc/init.d/nginx stop && boot_stop nginx
    rm -rf /usr/local/pcre
    rm -rf /usr/local/openssl
    rm -f /etc/init.d/nginx
    rm -rf /usr/local/nginx /usr/sbin/nginx /var/log/nginx /etc/logrotate.d/nginx cat
    echo ""
    echo "uninstalling PHP Sucess"
    [ -f /etc/init.d/php7-fpm ] && /etc/init.d/php7-fpm stop && boot_stop php7-fpm
    rm -rf /usr/local/php
    rm -rf /usr/bin/php /usr/bin/php-config /usr/bin/phpize /etc/php.ini
    echo ""
    echo "uninstalling Others software Sucess"
    [ -f /etc/init.d/redis-server ] && /etc/init.d/redis-server stop && boot_stop redis-server
    rm -f /etc/init.d/redis-server
    rm -rf /usr/local/redis
    rm -f /usr/bin/redis-cli
    rm -f /usr/bin/redis-server
    rm -rf /usr/local/libiconv /usr/lib64/libiconv.so.0 /usr/lib/libiconv.so.0
    rm -rf /usr/local/pcre
    rm -rf /usr/local/openssl
    echo
    echo "Successfully uninstall LAMP Sucess!"
}

while :
do
    read -p "Are you sure uninstall LNMP? (Default: n) (y/n)" uninstall
    [ -z ${uninstall} ] && uninstall="n"
    uninstall="`upcase_to_lowcase ${uninstall}`"
    case ${uninstall} in
        y) uninstall ; break;;
        n) echo "Uninstall cancelled, nothing to do" ; break;;
        *) echo "Input error!";;
    esac
done