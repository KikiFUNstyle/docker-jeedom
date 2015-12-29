#!/bin/bash
echo 'Start init'

if [ -z ${ROOT_PASSWORD} ]; then
	echo "Use default password : jeedom"
	echo "root:jeedom" | chpasswd
else
	echo "root:${ROOT_PASSWORD}" | chpasswd
fi

if [ -d /var/www/core ]; then
	echo 'Jeedom is already install'
else
	mkdir -p /var/www
	echo 'Jeedom not found install it'
	rm -rf /root/core-*
	wget https://github.com/jeedom/core/archive/beta.zip -O /tmp/jeedom.zip
	unzip -q /tmp/jeedom.zip -d /root/
	cp -R /root/core-*/* /var/www/
	cp -R /root/core-*/.htaccess /var/www/
fi

echo 'All init complete'
chmod 777 /dev/tty*
chmod 755 -R /var/www
chown -R www-data:www-data /var/www

echo 'Launch cron'
service cron start

echo 'Launch apache2'
service apache2 start

/usr/bin/supervisord

