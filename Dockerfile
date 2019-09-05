FROM bitnami/moodle:latest

# Configure PHP error_log to stderr, as in: https://docs.docker.com/config/containers/logging/
RUN echo "error_log = /dev/stderr" > /opt/bitnami/php/etc/conf.d/error_log.ini

# Prepare /var/local/cache
RUN mkdir -vp /var/local/cache && \
    chown -Rc bitnami:daemon /var/local/cache && \
    chmod ug+rwx /var/local/cache

# Enable opcache
# not working: https://github.com/bitnami/bitnami-docker-moodle/issues/100#issuecomment-527069683
#RUN sed -i 's/opcache.enable = Off/opcache.enable = 1/I' /opt/bitnami/php/etc/php.ini
RUN echo "opcache.enable = 1" > /opt/bitnami/php/etc/conf.d/opcache.ini

# Prepare PECL build tools
RUN apt-get update && \
    apt-get install -y gcc make autoconf libc-dev libssl-dev pkg-config

# Install PECL igbinary
# igbinary serializer & lzf compression is recommended: https://pdfs.semanticscholar.org/8395/e04cf62d03597e2a2e6a605ebc52bfa6ca7d.pdf 
RUN pecl channel-update pecl.php.net && \
    pecl install igbinary
RUN echo "extension=igbinary.so" > /opt/bitnami/php/etc/conf.d/igbinary.ini

# Install PECL redis
RUN pecl channel-update pecl.php.net
RUN yes | pecl install redis
RUN echo "extension=redis.so" > /opt/bitnami/php/etc/conf.d/redis.ini

# Install PECL mongodb
RUN pecl channel-update pecl.php.net && \
    pecl install mongodb
RUN echo "extension=mongodb.so" > /opt/bitnami/php/etc/conf.d/mongodb.ini
