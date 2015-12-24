#!/bin/bash
echo 'Start init'

if [ -z ${ROOT_PASSWORD} ]; then
	echo "Use default password : jeedom"
	echo "root:jeedom" | chpasswd
else
	echo "root:${ROOT_PASSWORD}" | chpasswd
fi

JEEDOM_INSTALL=1
if [ -d /var/www/html/core ]; then
	echo 'Jeedom is already install'
else
	echo 'Jeedom not found install it'
	JEEDOM_INSTALL=0
	cd /root
	rm -rf /root/core-*
	unzip -q jeedom.zip -d /root
	cp -R /root/core-*/* /var/www/html/
	cp /root/core-*/.htaccess /var/www/html/.htaccess
fi

if [ -f /var/www/html/core/config/common.config.php ]; then
	echo 'DB identification file found'
else
	echo 'Not DB file found, init env'
	MYSQL_HOST="127.0.0.1"
	MYSQL_PORT="3306"
	MYSQL_JEEDOM_DBNAME="jeedom"
	MYSQL_JEEDOM_USER="jeedom"
	MYSQL_JEEDOM_PASSWORD=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 15)
	ADMIN_PASSWORD=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 15)
	export ADMIN_PASSWORD
	DB_NAME=${MYSQL_JEEDOM_DBNAME}
	export DB_NAME
	DB_USER=${MYSQL_JEEDOM_USER}
	export DB_USER
	DB_PASSWORD=${MYSQL_JEEDOM_PASSWORD}
	export DB_PASSWORD
	./initdb.sh
	echo 'Create DB file'
	cp /var/www/html/core/config/common.config.sample.php /var/www/html/core/config/common.config.php
	sed -i "s/#HOST#/${MYSQL_HOST}/g" /var/www/html/core/config/common.config.php
	sed -i "s/#PORT#/${MYSQL_PORT}/g" /var/www/html/core/config/common.config.php
	sed -i "s/#DBNAME#/${MYSQL_JEEDOM_DBNAME}/g" /var/www/html/core/config/common.config.php
	sed -i "s/#USERNAME#/${MYSQL_JEEDOM_USER}/g" /var/www/html/core/config/common.config.php
	sed -i "s/#PASSWORD#/${MYSQL_JEEDOM_PASSWORD}/g" /var/www/html/core/config/common.config.php
fi
if [ ${JEEDOM_INSTALL} -eq 0 ]; then
	php /var/www/html/install/install.php mode=force
fi

echo 'All init complete'
chmod 777 /dev/tty*
chmod 755 -R /var/www/html/
chown -R www-data:www-data /var/www/html/

echo 'Launch mysql jeedom'
service mysql start

echo 'Launch cron'
service cron start

echo 'Launch apache2'
service apache2 start

echo 'Launch nodejs jeedom'
service jeedom start

/usr/bin/supervisord

