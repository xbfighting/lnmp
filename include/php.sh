#Install php
install_php7(){
    cd ${soft_dir}
    wget -S http://s2.wanggufeng.cn/php7.tar.gz -O /usr/local/src/php7.tar.gz && tar -zxvf /usr/local/src/php7.tar.gz -C /
    config_php

}

config_php(){
    rm -rf ${soft_dir}/ect/php-fpm.conf.bak php-fpm.conf.default php-fpm.d
    cp -r ./config/php-fpm.conf ${php7_location}/ect/php-fpm.conf
    cp -r ./config/php.ini ${php7_location}/ect/php.ini
    cp -r ./config/php7-fpm /etc/init.d/php7-fpm
    ln -s ${php7_location}/bin/php /usr/bin/php
    chmod 755 /etc/init.d/php7-fpm
    chkconfig --add php7-fpm
    chkconfig --level 3 php7-fpm on
}
