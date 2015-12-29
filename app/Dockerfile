FROM php:7-apache

MAINTAINER loic@jeedom.com

ENV SHELL_ROOT_PASSWORD jeedom

RUN apt-get update && apt-get install -y \
wget \
libssh2-php \
ntp \
unzip \
curl \
openssh-server \
supervisor \
cron \
usb-modeswitch \
python-serial \
nodejs \
npm \
tar \
libmcrypt-dev \
libcurl4-gnutls-dev \
libfreetype6-dev \
libjpeg62-turbo-dev \
libpng12-dev \
libxml2-dev \
sudo \
htop \
net-tools \
python \
ca-certificates \
vim \
git \
g++ \
locate \
mysql-client \
telnet \
man \
usbutils \
libtinyxml-dev \
libjsoncpp-dev \
snmp \
libsnmp-dev

####################################################################PHP7 EXTENSION#######################################################################################

RUN docker-php-ext-install json
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install curl
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install posix
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install sockets
RUN docker-php-ext-install zip
RUN docker-php-ext-install iconv
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install soap
RUN docker-php-ext-install snmp
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd

RUN rm /usr/bin/php
RUN ln -s /usr/local/bin/php /usr/bin/php 
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

####################################################################OPENZWAVE#######################################################################################

ADD https://raw.githubusercontent.com/jeedom/plugin-openzwave/master/ressources/install.sh /root/openzwave_install.sh
RUN chmod +x /root/openzwave_install.sh
RUN /root/openzwave_install.sh
RUN rm /root/openzwave_install.sh

####################################################################SYSTEM#######################################################################################

RUN echo "root:${SHELL_ROOT_PASSWORD}" | chpasswd && \
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

RUN mkdir -p /var/run/sshd /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

####################################################################APACHE#######################################################################################

RUN a2enmod proxy_http

####################################################################JEEDOM#######################################################################################
RUN echo "www-data ALL=(ALL) NOPASSWD: ALL" | (EDITOR="tee -a" visudo)
RUN echo "* * * * * su --shell=/bin/bash - www-data -c '/usr/bin/php /var/www/html/core/php/jeeCron.php' >> /dev/null" | crontab -

ADD bashrc /root/.bashrc
ADD init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]

EXPOSE 22 80 162 1886 4025 17100 10000 

#17100 : zibasdom
#10000 : orvibo
#1886 : MQTT
#162 : SNMP
#4025 : DSC
