#!/bin/sh

if [ -n "${NGINX_CONF}"]
then
    cp $NGINX_CONF /etc/nginx/nginx.conf
fi

if [ -n "${SITE_CONF}"]
then
    cp $SITE_CONF /etc/nginx/sites-enabled/default
fi

NGINX_DOCROOT="/app"
if [ -n "${DOCROOT}" ]
then
    NGINX_DOCROOT="$DOCROOT"
fi

sed -i "s#root .*;#root $NGINX_DOCROOT;#" /etc/nginx/sites-enabled/default
mkdir -p $NGINX_DOCROOT

if [ -z ${SYNC_UID+x} ]; then
    if [ $SYNC_UID -eq 1 ];
    then
        uid=`stat -c '%u' $DOCROOT`
        gid=`stat -c '%g' $DOCROOT`

        echo "Updating www-data ids to ($uid:$gid)"

        if [ ! $uid -eq 0 ]
        then
            sed -i "s#^www-data:x:.*:.*:#www-data:x:$uid:$gid:#" /etc/passwd
        fi

        if [ ! $gid -eq 0 ]
        then
            sed -i "s#^www-data:x:.*:#www-data:x:$gid:#" /etc/group
        fi

        chown www-data /var/log/nginx
    fi
fi
