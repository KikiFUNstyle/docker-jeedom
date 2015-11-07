#/bin/bash
if [ ! -d /var/lib/mysql/mysql ]; then
  cp -R /var/lib/mysql.bak/* /var/lib/mysql/
fi

if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo "Init DB"
  rm /var/lib/mysql/ib*
  service mysql start
  if [ ! -z ${DB_NAME+x} ] && [ ! -z ${DB_USER+x} ] && [ ! -z ${DB_PASSWORD+x} ]; then
    echo "Auto configuring db '$DB_NAME' with user '$DB_USER' and password '$DB_PASSWORD'"
    echo "CREATE DATABASE $DB_NAME;" | mysql -uroot -proot
    echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" | mysql -uroot -proot
    echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" | mysql -uroot -proot
  fi
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$ADMIN_PASSWORD')" | mysql -uroot -proot
fi
echo "DB installed"