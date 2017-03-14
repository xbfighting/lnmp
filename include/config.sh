load_config(){
    current_dir=`pwd`

    #Softdir location
    soft_dir=${current_dir}/soft

    #Configs location
    config_redis=${current_dir}/config/redis.conf
    config_nginx=${current_dir}/config/nginx.conf

    #Install location
    nginx_location=/usr/local/nginx
    mysql_location=/usr/local/mysql
    redis_location=/usr/local/redis
    php7_location=/usr/local/php7

    #Install location
    depends_prefix=/usr/local

    #Web root location
    web_root_dir=/data/www/default

}
