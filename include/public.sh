public_install(){
    cd ${soft_dir}
    rm -rf ./*
    #public install
    yum -y install gcc cmake make zip unzip wget gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers openssl-devel pcre-devel zlib-devel wget gd libxml2 libxml2-devel libtool libmcrypt
    useradd -s /sbin/nologin -M www
    #down software
    untar ${download_root_url}/mysql-5.6.34.tar.gz
    untar ${download_root_url}/memcache-2.2.7.tgz
    untar ${download_root_url}/nginx-1.8.0.tar.gz
    untar ${download_root_url}/pcre-8.36.tar.gz
    untar ${download_root_url}/redis-3.2.0.tar.gz
    untar ${download_root_url}/yaf-2.3.5.tgz
    untar ${download_root_url}/mongo-1.4.5.tgz
    untar ${download_root_url}/openssl-1.0.1e.tar.gz
    untar ${download_root_url}/php-5.6.8.tar.gz
    untar ${download_root_url}/redis-2.2.7.tgz
    untar ${download_root_url}/swoole-src-master.zip
}

lanp_install(){
    install_tool
    rootness
    sync_time
    install_redis
    install_nginx
    install_php
    install_mysql
    clear_packet
}

clear_packet(){
    rm -rf ${soft_dir}/memcache-2.2.7
    rm -rf ${soft_dir}/mongo-1.4.5
    rm -rf ${soft_dir}/nginx-1.8.0
    rm -rf ${soft_dir}/openssl-1.0.1e
    rm -rf ${soft_dir}/pcre-8.36
    rm -rf ${soft_dir}/php7.tar.g
    rm -rf ${soft_dir}/redis-2.2.7
    rm -rf ${soft_dir}/redis-3.2.0
    rm -rf ${soft_dir}/swoole-src-master
    rm -rf ${soft_dir}/php-5.6.8
    rm -rf ${soft_dir}/yaf-2.3.5
    rm -rf ${soft_dir}/mysql-5.6.34
    rm -rf ${soft_dir}/package.xml
}

generate_password(){
    cat /dev/urandom | head -1 | md5sum | head -c 8
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

#Check system
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

check_command_exist(){
    if [ ! "$(command -v "${1}")" ]; then
        echo "${1} is not installed, please install it and try again."
        exit 1
    fi
}

install_tool(){
    if check_sys packageManager apt; then
        apt-get -y update
        apt-get -y install gcc g++ make wget perl curl bzip2 libreadline-dev
    elif check_sys packageManager yum; then
        yum -y install gcc gcc-c++ make wget perl curl bzip2 readline readline-devel
        if centosversion 5; then
            yum -y install gcc44 gcc44-c++
            export CC=/usr/bin/gcc44
            export CXX=/usr/bin/g++44
        fi
    fi
    check_command_exist "gcc"
    check_command_exist "g++"
    check_command_exist "make"
    check_command_exist "wget"
    check_command_exist "perl"
}

get_ip(){
    local IP=$( ip addr | egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | egrep -v "^192\.168|^172\.1[6-9]\.|^172\.2[0-9]\.|^172\.3[0-2]\.|^10\.|^127\.|^255\.|^0\." | head -n 1 )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipv4.icanhazip.com )
    [ -z ${IP} ] && IP=$( wget -qO- -t1 -T2 ipinfo.io/ip )
    [ ! -z ${IP} ] && echo ${IP} || echo
}

untar(){
    cd ${soft_dir}
    local tarball_type
    local cur_dir=`pwd`
    if [ -n $1 ]; then
        software_name=`echo $1 | awk -F/ '{print $NF}'`
        tarball_type=`echo $1 | awk -F. '{print $NF}'`
        wget -c -t3 -T3 $1 -P ${cur_dir}/
        if [ $? -ne 0 ]; then
            rm -rf ${cur_dir}/${software_name}
            wget -c -t3 -T60 $2 -P ${cur_dir}/
            software_name=`echo $2 | awk -F/ '{print $NF}'`
            tarball_type=`echo $2 | awk -F. '{print $NF}'`
        fi
    else
        software_name=`echo $2 | awk -F/ '{print $NF}'`
        tarball_type=`echo $2 | awk -F. '{print $NF}'`
        wget -c -t3 -T3 $2 -P ${cur_dir}/ || exit
    fi
    extracted_dir=`tar tf ${cur_dir}/${software_name} | tail -n 1 | awk -F/ '{print $1}'`
    case ${tarball_type} in
        gz|tgz)
            tar zxf ${cur_dir}/${software_name} -C ${cur_dir}/ || return 1
        ;;
        bz2|tbz)
            tar jxf ${cur_dir}/${software_name} -C ${cur_dir}/ || return 1
        ;;
        xz)
            tar Jxf ${cur_dir}/${software_name} -C ${cur_dir}/ || return 1
        ;;
        tar|Z)
            tar xf ${cur_dir}/${software_name} -C ${cur_dir}/ || return 1
        ;;
        zip)
            unzip ${cur_dir}/${software_name} -d ${cur_dir}/ || return 1
        ;;
        *)
        echo "${software_name} is wrong tarball type ! "
    esac
}

#Get OS name
get_opsy(){
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}

#Get OS info
get_os_info(){
    local cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    local cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
    local freq=$( awk -F: '/cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
    local tram=$( free -m | awk '/Mem/ {print $2}' )
    local swap=$( free -m | awk '/Swap/ {print $2}' )
    local up=$( awk '{a=$1/86400;b=($1%86400)/3600;c=($1%3600)/60;d=$1%60} {printf("%ddays, %d:%d:%d\n",a,b,c,d)}' /proc/uptime )
    local load=$( w | head -1 | awk -F'load average:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
    local opsy=$( get_opsy )
    local arch=$( uname -m )
    local lbit=$( getconf LONG_BIT )
    local host=$( hostname )
    local kern=$( uname -r )
    local ramsum=$( expr $tram + $swap )
    if [ ${ramsum} -lt 480 ]; then
        echo "Error: Not enough memory to install LAMP. The system needs memory: ${tram}MB*RAM + ${swap}MB*Swap > 480MB"
        exit 1
    fi
    [ ${ramsum} -lt 600 ] && disable_fileinfo="--disable-fileinfo" || disable_fileinfo=""

    echo "########## System Information ##########"
    echo
    echo "CPU model            : ${cname}"
    echo "Number of cores      : ${cores}"
    echo "CPU frequency        : ${freq} MHz"
    echo "Total amount of ram  : ${tram} MB"
    echo "Total amount of swap : ${swap} MB"
    echo "System uptime        : ${up}"
    echo "Load average         : ${load}"
    echo "OS                   : ${opsy}"
    echo "Arch                 : ${arch} (${lbit} Bit)"
    echo "Kernel               : ${kern}"
    echo "Hostname             : ${host}"
    echo "IPv4 address         : $(get_ip)"
    echo
    echo "########################################"
}