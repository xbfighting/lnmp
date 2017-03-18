#Install mysql
install_mysql(){
    if [ ! -d "/usr/local/mysql" ]; then
        useradd -s /sbin/nologin -M mysql
        cd ${soft_dir}/mysql-5.6.34
        cmake -DCMAKE_INSTALL_PREFIX=${mysql_location} -DMYSQL_DATADIR=${mysql_location}/data -DSYSCONFDIR=/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci
        make && make install
        config_mysql
        start_mysql
    fi
}

config_mysql(){
    chown -R mysql:mysql ${mysql_location}
    cd ${mysql_location}
    scripts/mysql_install_db --basedir=${mysql_location} --datadir=${mysql_location}/data --user=mysql
    cp support-files/mysql.server /etc/init.d/mysqld
}

start_mysql(){
    chmod 755 /etc/init.d/mysqld
    chkconfig --add mysqld
    chkconfig --level 3 mysqld on
    service mysqld start
}