#Install php
install_php(){
    if [ ! -d "/usr/local/php7" ]; then
        cd ${soft_dir}
        wget -S http://s2.wanggufeng.cn/php7.tar.gz -O /usr/local/src/php7.tar.gz && tar -zxvf /usr/local/src/php7.tar.gz -C /
        config_php
    fi
}

config_php(){
    rm -rf ${php7_location}/ect/php-fpm.conf.bak
    rm -rf ${php7_location}/php-fpm.conf.default
    rm -rf ${php7_location}/php-fpm.d
    rm -rf /usr/bin/php
    cp -r ${current_dir}/config/php-fpm.conf ${php7_location}/etc/php-fpm.conf
    cp -r ${current_dir}/config/php.ini ${php7_location}/etc/php.ini
    cp -r ${current_dir}/config/php7-fpm /etc/init.d/php7-fpm
    ln -s ${php7_location}/bin/php /usr/bin/php
    chmod 755 /etc/init.d/php7-fpm
    chkconfig --add php7-fpm
    chkconfig --level 3 php7-fpm on
}
