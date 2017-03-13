#Install pcre
install_pcre(){
    cd ${soft_dir}/pcre-8.36
    ./configure --prefix=/usr/local/pcre
    make && make install
}

#Install openssl
install_openssl(){
    cd ${soft_dir}/openssl-1.0.1e
    ./config --prefix=/usr/local/openssl
    make && make install
}
#Install nginx
install_nginx(){
    cd ${soft_dir}/nginx-1.8.0
    ./configure --prefix=/usr/local/nginx --with-openssl=/usr/local/src/openssl-1.0.1e --with-pcre=/usr/local/src/pcre-8.36 --with-http_ssl_module --user=www --group=www
    make && make install
}