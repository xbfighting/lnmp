load_config(){
    current_dir=`pwd`
    #Softdir location
    soft_dir=${current_dir}/soft

    #Download URL
    download_root_url="http://s0.diycode.me/"

    #Configs location
    config_redis=${current_dir}/config/redis.conf
    config_nginx=${current_dir}/config/nginx.conf

    #Install location
    nginx_location=/usr/local/nginx
    pcre_location=/usr/local/pcre
    openssl_location=/usr/local/openssl
    mysql_location=/usr/local/mysql
    redis_location=/usr/local/redis
    php7_location=/usr/local/php7

    #Install location
    depends_prefix=/usr/local

    #Web root location
    web_root_dir=/data/www/default

    #Ipaddress local
    ipaddress=`ifconfig|grep "inet addr:*.*.*.* Bcast:*.*.*.* Mask:*.*.*.*" | grep -v '127.0.0.1' | cut -d: -f2 | awk 'NR==1{print $1}'`

}