FROM phusion/baseimage:latest
MAINTAINER Mario Rogic <hello@mario.net.au>

# Install base packages
ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

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
