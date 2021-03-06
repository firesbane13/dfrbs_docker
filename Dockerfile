FROM debian:stretch

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y wget gnupg gnupg2 gnupg1 apt-utils vim

RUN apt-get install -y apt-transport-https lsb-release ca-certificates && \
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Only needed if installing PHP7.2
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - && \
    echo "deb https://packages.sury.org/php/ stretch main" | tee /etc/apt/sources.list.d/php.list

RUN DEBIAN_FRONTEND=noninterative \
    apt-get update && \
    apt-get install -y apache2 \
                       php7.2 \
                       php7.2-mysql \
                       libapache2-mod-php7.2 \
                       curl \
                       php7.2-curl \
                       php-mcrypt \
                       php7.2-dom \
                       supervisor \
                       unzip

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update

RUN a2enmod php7.2 && \
    a2enmod rewrite && \
    a2enmod proxy && \
    a2enmod proxy_http

# Change php error logging to errors and warnings
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.2/apache2/php.ini

env APACHE_RUN_USER     www-data
env APACHE_RUN_GROUP    www-data
env APACHE_PID_FILE     /var/run/apache2.pid
env APACHE_RUN_DIR      /var/run/apache2
env APACHE_LOCK_DIR     /var/lock/apache2
env APACHE_LOG_DIR      /var/log/apache2

# Expose apache
EXPOSE 80

ADD . /var/www/html/site
WORKDIR /var/www/html/site
RUN chown -R www-data .

ADD apache2/apache-config.conf /etc/apache2/sites-enabled/000-default.conf

CMD /usr/sbin/apache2ctl -D FOREGROUND
