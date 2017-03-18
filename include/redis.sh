#Install redis
install_redis(){
    cd ${soft_dir}/redis-3.2.0
    make && make PREFIX=${redis_location} install
    config_redis
    start_redis
}

config_redis(){
    mkdir -p ${redis_location}/etc/
    cp -r $config_redis ${redis_location}/etc/redis.conf
    ln -s ${redis_location}/bin/redis-cli /usr/bin/redis-cli
    ln -s ${redis_location}/bin/redis-server /usr/bin/redis-server
    cp -r ${current_dir}/config/redis-server /etc/init.d/redis-server
}

start_redis(){
    chmod 755 /etc/init.d/redis-server
    chkconfig --add redis-server
    chkconfig --level 3 redis-server on
    /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf
}