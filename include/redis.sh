#Install redis
install_redis(){
    cd ${soft_dir}/redis-3.2.0
    make && make PREFIX=${redis_location} install
    config_redis
}

config_redis(){
    cp -r $config_redis ${redis_location}/redis.conf
    ln -s ${redis_location}/bin/redis-cli /usr/bin/redis-cli
    ln -s ${redis_location}/bin/redis-server /usr/bin/redis-server
}