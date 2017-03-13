pubs_install(){
    cd ${soft_dir}
    #public install
    yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers openssl-devel pcre-devel zlib-devel wget gd libxml2 libxml2-devel libtool libmcrypt
    #down software
    useradd -s /sbin/nologin -M www
    cd ${soft_dir}
    wget http://s1.wanggufeng.cn/lnmp.zip
    unzip lnmp.zip -d . && rm -rf lnmp.zip
    #tar software
    cd ./lnmp
    tar -zxvf memcache-2.2.7.tgz
    tar -zxvf mongo-1.4.5.tgz
    tar -zxvf nginx-1.8.0.tar.gz
    tar -zxvf openssl-1.0.1e.tar.gz
    tar -zxvf pcre-8.36.tar.gz
    tar -zxvf php-5.6.8.tar.gz
    tar -zxvf redis-2.2.7.tgz
    tar -zxvf yaf-2.3.5.tgz
    tar -zxvf redis-3.2.0.tar.gz
    unzip swoole-src-master.zip
    #rm software
    rm -rf memcache-2.2.7.tgz
    rm -rf mongo-1.4.5.tgz
    rm -rf nginx-1.8.0.tar.gz
    rm -rf openssl-1.0.1e.tar.gz
    rm -rf pcre-8.36.tar.gz
    rm -rf php-5.6.8.tar.gz
    rm -rf redis-2.2.7.tgz
    rm -rf swoole-src-master.zip
    rm -rf yaf-2.3.5.tgz
    rm -rf redis-3.2.0.tar.gz
    rm -rf package.xml
    rm -rf php-5.6.8
}

lanp_install(){
    #install_pcre
    #install_openssl
    #install_nginx
    #install_mysql
    install_php7
    #redis_preinstall_settings
}

rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}

boot_start(){
    if check_sys packageManager apt; then
        update-rc.d -f $1 defaults
    elif check_sys packageManager yum; then
        chkconfig --add $1
        chkconfig $1 on
    fi
}

boot_stop(){
    if check_sys packageManager apt; then
        update-rc.d -f $1 remove
    elif check_sys packageManager yum; then
        chkconfig $1 off
        chkconfig --remove $1
    fi
}

upcase_to_lowcase(){
    echo $1 | tr '[A-Z]' '[a-z]'
}

filter_location(){
    local location=$1
    if ! echo $location | grep -q "^/"; then
        while true
        do
            read -p "Input error, please input location again: " location
            echo $location | grep -q "^/" && echo $location && break
        done
    else
        echo $location
    fi
}

is_64bit(){
    if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ]; then
        return 0
    else
        return 1
    fi
}

check_command_exist(){
    if [ ! "$(command -v "${1}")" ]; then
        echo "${1} is not installed, please install it and try again."
        exit 1
    fi
}

download_file(){
    if [ -s $1 ]; then
        echo "$1 [found]"
    else
        echo "$1 not found!!!download now..."
        if ! wget -c -t3 -T60 ${download_root_url}/$1; then
            echo "Failed to download $1, please download it to ${cur_dir} directory manually and try again."
            exit 1
        fi
    fi
}

disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

sync_time(){
    echo "Start to sync time..."
    if check_sys sysRelease ubuntu || check_sys sysRelease debian; then
        apt-get -y update
        apt-get -y install ntpdate
        check_command_exist ntpdate
        ntpdate -d cn.pool.ntp.org
    elif check_sys sysRelease centos; then
        yum -y install ntp which
        check_command_exist ntpdate
        ntpdate -d cn.pool.ntp.org
    fi
    rm -f /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    ntpdate -v time.nist.gov
    /sbin/hwclock -w
    echo "Sync time completed..."
}

check_sys(){
    local checkType=$1
    local value=$2

    local release=''
    local systemPackage=''

    if [[ -f /etc/redhat-release ]]; then
        release="centos"
        systemPackage="yum"
    elif cat /etc/issue | grep -Eqi "debian"; then
        release="debian"
        systemPackage="apt"
    elif cat /etc/issue | grep -Eqi "ubuntu"; then
        release="ubuntu"
        systemPackage="apt"
    elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
        systemPackage="yum"
    elif cat /proc/version | grep -Eqi "debian"; then
        release="debian"
        systemPackage="apt"
    elif cat /proc/version | grep -Eqi "ubuntu"; then
        release="ubuntu"
        systemPackage="apt"
    elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
        release="centos"
        systemPackage="yum"
    fi

    if [[ ${checkType} == "sysRelease" ]]; then
        if [ "$value" == "$release" ]; then
            return 0
        else
            return 1
        fi
    elif [[ ${checkType} == "packageManager" ]]; then
        if [ "$value" == "$systemPackage" ]; then
            return 0
        else
            return 1
        fi
    fi
}