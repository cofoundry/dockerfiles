#!/usr/bin/env sh

if [ ! -d /var/lib/mysql/mysql ]; then
    echo 'Rebuilding mysql data dir'

    chown -R mysql.mysql /var/lib/mysql
    mysql_install_db > /dev/null

    rm -rf /var/run/mysqld/*

    echo 'Starting mysqld'
    # The sleep 1 is there to make sure that inotifywait starts up before the socket is created
    mysqld_safe &

    echo 'Waiting for mysqld to come online'
    while [ ! -x /var/run/mysqld/mysqld.sock ]; do
        sleep 1
    done

    # echo 'Setting root password to root'
    /usr/bin/mysqladmin -u root password 'root'

    echo 'Setting up database'
    mysql -uroot -proot -e "CREATE DATABASE ${MYSQL_DB}"

    echo 'Setting up mysql user'
    mysql -uroot -proot -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}'"
    mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION"

    if [ -d /var/lib/mysql/setup ]; then
        echo 'Found /var/lib/mysql/setup - scanning for SQL scripts'
        for sql in $(ls /var/lib/mysql/setup/*.sql 2>/dev/null | sort); do
            echo 'Running script:' $sql
            mysql -uroot -proot -e "\. $sql"
            mv $sql $sql.processed
        done
    else
        echo 'No setup directory with extra sql scripts to run'
    fi

    echo 'Shutting down mysqld'
    mysqladmin -uroot -proot shutdown
else
    echo 'Skipping setup, /var/lib/mysql/mysql exists...'
fi
