#!/bin/sh

if [ -n "${NGINX_CONF}" ]
then
    cp $NGINX_CONF /etc/nginx/nginx.conf
fi

if [ -n "${SITE_CONF}" ]
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
