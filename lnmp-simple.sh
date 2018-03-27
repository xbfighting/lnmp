##
# * Nginx
# * PHP
# * MySQL
##
# Usage: sh ./lnmp-simple.sh
#
# 检查 root 权限
[ "$(id -g)" != '0' ] && die 'Script must be run as root.'
# 声明变量
ipAddress=$(ip addr | grep -E -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -E -v "^192\\.168|^172\\.1[6-9]\\.|^172\\.2[0-9]\\.|^172\\.3[0-2]\\.|^10\\.|^127\\.|^255\\." | head -n 1) || '0.0.0.0'
mysqlPWD=$(echo -n ${RANDOM} | md5sum | cut -b -16)
# 输出正确信息
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
    sudo yum -y install nginx
    #启动nginx
    sudo service nginx start

    #安装php 和php-fpm软件包
    sudo yum -y install php php-fpm
    #启动php-fpm服务
    sudo service php-fpm start

    #安装mysql
    sudo yum -y install mysql-server
    #启动mysql
    sudo service mysqld start
    #执行mysl安全检查
    sudo mysql_secure_installation

    #安装php-mysqlnd 扩展
    sudo yum -y install php-mysqlnd
    
    #重启php-fpm服务进程
    sudo service php-fpm restart

    if [[ -f "/usr/sbin/mysqld_safe" || -f "/usr/sbin/php-fpm" || -f "/usr/sbin/nginx" ]]; then
      echo "================================================================"
      echo -e "\\033[42m Install completed. \\033[0m"
      echo -e "\\033[34m WebSite: \\033[0m http://${ipAddress}"
      echo -e "\\033[34m WebDir: \\033[0m /home/wwwroot/"
      echo -e "\\033[34m Nginx: \\033[0m /etc/nginx/"
      echo -e "\\033[34m PHP: \\033[0m /etc/php-fpm.d/"
      echo -e "\\033[34m MySQL Data: \\033[0m /var/lib/mysql/"
      echo -e "\\033[34m MySQL User: \\033[0m root"
      echo -e "\\033[34m MySQL Password: \\033[0m ${mysqlPWD}"
      echo "Start time: ${startDate}"
      echo "Completion time: $(date) (Use: $((($(date +%s)-startDateSecond)/60)) minute)"
      echo "Use: $((($(date +%s)-startDateSecond)/60)) minute"
      echo "================================================================"
     else
      echo -e "\\033[41m Sorry, Install Failed. \\033[0m"
    fi
}
runUnstall(){
  showNotice 'Unstalling...'  
  sudo yum remove -y nginx
  sudo yum remove -y php php-fpm
  sudo yum remove -y mysql-server php-mysqlnd
  sudo rm -fr /var/lib/mysql/*  
  sudo rm /var/lock/subsys/mysqld   
  sudo killall mysqld  
  echo -e "\\033[42m Unstall completed. \\033[0m"
}
#run install
runInstall
