FROM debian:8.11

MAINTAINER takara

WORKDIR /root

RUN apt-get -y update
RUN apt-get install -y wget apt-transport-https lsb-release ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
RUN wget https://dev.mysql.com/get/mysql-apt-config_0.8.3-1_all.deb

ENV DEBIAN_FRONTEND noninteractive
RUN dpkg -i mysql-apt-config_0.8.3-1_all.deb 
RUN apt-get -y update
RUN apt-get -y install net-tools git make apache2
RUN apt-get -y install vim curl chkconfig gcc libpcre3-dev unzip locales
RUN apt-get -y install php5.6 php-pear php5.6-mysql php5.6-curl php5.6-mbstring php5.6-zip \
    php5.6-cli php5.6-common php5.6-json php5.6-opcache php5.6-readline php5.6-xml php5.6-xdebug php5.6-apc \
    php5.6-bcmath php5.6-bz2 php5.6-curl php5.6-dba php5.6-dom php5.6-gd php5.6-imagick php5.6-mbstring
RUN apt-get -y install imagemagick
RUN apt-get -y install mysql-community-server
RUN apt-get -y install postfix mailutils
ENV DEBIAN_FRONTEND dialog

VOLUME /var/lib/mysql

# tty停止
COPY asset/ttystop /etc/init.d/
RUN chkconfig --add ttystop
RUN chkconfig ttystop on

RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# composer
RUN curl -s http://getcomposer.org/installer | php
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

RUN composer global require hirak/prestissimo

RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LC_CTYPE ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

#COPY asset/my.cnf /etc/mysql/
COPY asset/mysqld.cnf /etc/mysql/mysql.conf.d/

EXPOSE 80

RUN a2enmod ssl && \
    a2enmod rewrite && \
    a2enmod expires && \
    a2enmod headers && \
    a2dismod -f autoindex && \
    a2dismod -f negotiation


COPY asset/apache2.conf /etc/apache2/
COPY asset/php.ini /etc/php/5.6/apache2/

CMD ["/sbin/init", "3"]

