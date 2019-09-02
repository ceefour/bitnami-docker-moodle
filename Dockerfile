FROM bitnami/moodle:latest

# Prepare /var/local/cache
RUN mkdir -vp /var/local/cache
RUN chown -Rc bitnami:daemon /var/local/cache
RUN chmod ug+rwx /var/local/cache

# Enable opcache
RUN sed -i 's/opcache.enable = Off/opcache.enable = 1/I' /opt/bitnami/php/conf/php.ini

# Install PECL mongodb
RUN apt update
RUN apt install autoconf libssl-dev pkg-config build-essential
RUN pecl channel-update pecl.php.net
RUN pecl install mongodb
RUN echo "extension=mongodb.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
