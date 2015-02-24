FROM phusion/baseimage:latest
MAINTAINER Mario Rogic <hello@mario.net.au>

# Env vars
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Reset host keys
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Build packages first
COPY ./packages.sh /build/packages.sh
RUN /build/packages.sh

COPY ./nginx /build/nginx
RUN /build/nginx/setup.sh

COPY ./php-fpm /build/php-fpm
RUN /build/php-fpm/setup.sh

COPY ./composer /build/composer
RUN /build/composer/setup.sh

# Fix perms for our volume mounts
RUN usermod -u 1000 www-data

EXPOSE 80
WORKDIR /app
CMD ["/sbin/my_init"]

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
