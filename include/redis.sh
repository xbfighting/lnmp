#Install redis
redis_preinstall_settings(){
    cd ${soft_dir}/redis-3.2.0
    make && make PREFIX=/usr/local/redis install
    cp -r $config_redis /usr/local/redis/
}