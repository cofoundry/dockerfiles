#!/bin/sh
cp -a /build/nginx/site-default /etc/nginx/sites-available/default
cp -a /build/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure nginx (docroot and front controller) on startup
cp -a /build/nginx/init.sh /etc/my_init.d/00_configure_nginx.sh
chmod +x /etc/my_init.d/00_configure_nginx.sh

# Configure nginx to start as a service
mkdir /etc/service/nginx
cp -a /build/nginx/runit.sh /etc/service/nginx/run
chmod +x /etc/service/nginx/run
