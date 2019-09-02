FROM bitnami/moodle:latest

# Prepare /var/local/cache
RUN mkdir -vp /var/local/cache && \
    chown -Rc bitnami:daemon /var/local/cache && \
    chmod ug+rwx /var/local/cache

# Enable opcache
# not working: https://github.com/bitnami/bitnami-docker-moodle/issues/100#issuecomment-527069683
#RUN sed -i 's/opcache.enable = Off/opcache.enable = 1/I' /opt/bitnami/php/etc/php.ini
RUN echo "opcache.enable = 1" > /opt/bitnami/php/etc/conf.d/opcache.ini

# Install PECL mongodb
RUN apt-get update && \
    apt-get install -y autoconf libssl-dev pkg-config build-essential
RUN pecl channel-update pecl.php.net && \
    pecl install mongodb
RUN echo "extension=mongodb.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"`
