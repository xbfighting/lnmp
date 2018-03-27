#!/bin/bash
#
#
# AWS AIM LNMP
#
# * Nginx
# * PHP 5.6
# * MySQL
##
# Usage: sh ./lnmp-simple.sh
#
# 检查 root 权限
[ "$(id -g)" != '0' ] && die 'Script must be run as root.'
# 声明变量
#ipAddress=$(ip addr | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -E -v "^192\\.168|^172\\.1[6-9]\\.|^172\\.2[0-9]\\.|^172\\.3[0-2]\\.|^10\\.|^127\\.|^255\\." | head -n 1) || '0.0.0.0'
#mysqlPWD=$(echo -n ${RANDOM} | md5sum | cut -b -16)
ipAddress=""
mysqlPWD=$(echo -n ${RANDOM} | md5sum | cut -b -16)
showOk(){
  echo -e "\\033[34m[OK]\\033[0m $1"
}
# 输出错误信息
showError(){
  echo -e "\\033[31m[ERROR]\\033[0m $1"
}
# 输出提示信息
showNotice(){
  echo -e "\\033[36m[NOTICE]\\033[0m $1"
}
# 安装
runInstall(){
  startDate=$(date)
  startDateSecond=$(date +%s)

  showNotice 'Installing...'

  showNotice 'Please input server IPv4 Address'
    read -p "IP address: " -r -e -i "${ipAddress}" ipAddress
    if [ "${ipAddress}" = '' ]; then
      showError 'Invalid IP Address'
      exit
    fi
    #安装nginx
    sudo yum install nginx 
    #启动nginx
    sudo service nginx start  
    #安装php 和php-fpm软件包
    sudo yum -y install php56 php56-fpm  
    #启动php56-fpm服务
    sudo service php-fpm start
    # 安装mysql
    sudo yum -y install mysql
    #安装 mysql56-server
    sudo yum -y install mysql56-server
    #mysql初始化，在mysql中建立起系统表
    sudo mysql_install_db
    #安装php-mysqlnd 扩展
    sudo yum -y install php56-mysqlnd
    #重启php-fpm服务进程
    sudo service php-fpm restart
    sudo yum remove -y nginx php56 php56-server php56-mysqlnd mysql
    if [[ -f "/usr/sbin/mysqld_safe" || -f "/usr/sbin/php-fpm" || -f "/usr/sbin/nginx" ]]; then
      echo "================================================================"
      echo -e "\\033[42m [LNMP] Install completed. \\033[0m"
      echo -e "\\033[34m WebSite: \\033[0m http://${ipAddress}"
      echo -e "\\033[34m WebDir: \\033[0m /home/wwwroot/"
      echo -e "\\033[34m Nginx: \\033[0m /etc/nginx/"
      /usr/sbin/nginx -v
      echo -e "\\033[34m PHP: \\033[0m /etc/php-fpm.d/"
      /usr/sbin/php-fpm -v

    echo -e "\\033[34m MySQL Data: \\033[0m /var/lib/mysql/"
        echo -e "\\033[34m MySQL User: \\033[0m root"
        echo -e "\\033[34m MySQL Password: \\033[0m ${mysqlPWD}"
        /usr/sbin/mysqld -V


    echo "Start time: ${startDate}"
        echo "Completion time: $(date) (Use: $((($(date +%s)-startDateSecond)/60)) minute)"
        echo "Use: $((($(date +%s)-startDateSecond)/60)) minute"
        echo "For more details see \\033[4mhttps://git.io/lnmp\\033[0m"
        echo "================================================================"
      else
        echo -e "\\033[41m [LNMP] Sorry, Install Failed. \\033[0m"
        echo "Please contact us: https://github.com/maicong/LNMP/issues"
      fi
    }
