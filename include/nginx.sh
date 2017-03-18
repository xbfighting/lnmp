#Install pcre
install_pcre(){
    if [ ! -d "/usr/local/pcre" ]; then
        cd ${soft_dir}/pcre-8.36
        ./configure --prefix=/usr/local/pcre
        make && make install
    fi
}

#Install openssl
install_openssl(){
    if [ ! -d "/usr/local/openssl" ]; then
        cd ${soft_dir}/openssl-1.0.1e
        ./config --prefix=/usr/local/openssl
        make && make install
    fi
}

#Install nginx
install_nginx(){
    if [ ! -d "/usr/local/nginx" ]; then
        install_pcre
        install_openssl
        cd ${soft_dir}/nginx-1.8.0
        ./configure --prefix=/usr/local/nginx --with-openssl=${soft_dir}/openssl-1.0.1e --with-pcre=${soft_dir}/pcre-8.36 --with-http_ssl_module --user=www --group=www
        make && make install
        config_nginx
        start_nginx
    fi
}

#Config nginx
config_nginx(){
    cp -r ${current_dir}/config/upstream.conf ${nginx_location}/conf/upstream.conf
    cp -r ${config_nginx} ${nginx_location}/conf/nginx.conf
    cp -r ${current_dir}/config/nginx /etc/init.d/nginx
    mkdir -p ${nginx_location}/conf/vhost/
    cp -r ${current_dir}/config/info.local.conf ${nginx_location}/conf/vhost/info.local.conf
    mkdir -p /data/html/test
    cp -r ${current_dir}/config/phpinfo.php /data/html/test
}

#Start nginx
start_nginx(){
    chmod 755 /etc/init.d/nginx
    chkconfig --add nginx
    chkconfig --level 3 nginx on
    /etc/init.d/nginx start
}