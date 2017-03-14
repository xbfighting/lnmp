#Install redis
install_redis(){
    cd ${soft_dir}/redis-3.2.0
    make && make PREFIX=/usr/local/redis install
    config_redis
}

config_redis(){
    cp -r $config_redis /usr/local/redis/redis.conf
    ln -s ${redis_location}/bin/redis-cli /usr/bin/redis-cli
    ln -s ${redis_location}/bin/redis-server /usr/bin/redis-server
}