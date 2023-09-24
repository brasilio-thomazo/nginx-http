FROM alpine:latest

ENV POOL_UID=1000
ENV POOL_GID=1000

RUN apk add --no-cache --no-interactive php81-zip php81-xsl php81-xmlwriter \
    php81-xmlreader php81-xml php81-tokenizer php81-tidy \
    php81-sysvshm php81-sysvsem php81-sysvmsg php81-sqlite3 \
    php81-sodium php81-sockets php81-soap php81-snmp \
    php81-simplexml php81-shmop php81-session php81-pspell \
    php81-posix php81-phpdbg php81-phar php81-pgsql php81-pecl-yaml \
    php81-pecl-uuid php81-pecl-uploadprogress php81-pecl-ssh2 \
    php81-pecl-redis php81-pecl-protobuf php81-pecl-mongodb \
    php81-pecl-memcached php81-pecl-memcache php81-pecl-imagick \
    php81-pear php81-pdo_sqlite php81-pdo_pgsql php81-pdo_odbc \
    php81-pdo_mysql php81-pdo_dblib php81-pdo php81-pcntl php81-openssl \
    php81-opcache php81-odbc php81-mysqlnd php81-mysqli php81-mbstring \
    php81-litespeed php81-ldap php81-intl php81-imap php81-iconv php81-gmp \
    php81-gettext php81-gd php81-ftp php81-fpm php81-fileinfo php81-ffi \
    php81-exif php81-enchant php81-embed php81-dom php81-dba php81-curl \
    php81-ctype php81-common php81-cgi php81-calendar php81-bz2 php81-brotli \
    php81-bcmath php81 bash composer icu-data-full nginx doas

RUN addgroup -g ${POOL_GID} app
RUN adduser -h /home/app -G app -u ${POOL_UID} -s /bin/bash -D app
RUN mkdir -p /home/www/public /run/php && chown ${POOL_UID}:${POOL_GID} /home/www -R
RUN echo 'permit app as root' >> /etc/doas.d/doas.conf
RUN echo 'permit nopass app as root' >> /etc/doas.d/doas.conf

EXPOSE 80

COPY php-fpm.ini /etc/php81/php-fpm.conf
COPY www.ini /etc/php81/php-fpm.d/www.conf
COPY policy.xml /etc/ImageMagick-7/policy.xml
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/http.d/default.conf
COPY entrypoint /entrypoint

USER app
WORKDIR /home/www

ENTRYPOINT [ "sh", "/entrypoint" ]