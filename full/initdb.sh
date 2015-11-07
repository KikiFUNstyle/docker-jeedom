#/bin/bash
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo "Init db"
  killall mysqld
  rm /var/lib/mysql/ib*
  /usr/bin/mysqld_safe &
  sleep 10s
  echo "GRANT ALL ON *.* TO $ADMIN_USER@'%' IDENTIFIED BY '$ADMIN_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -uroot -proot
  if [ $?  -ne 0 ]; then
    echo 'Error on start mysqlsafe'
    exit 1
  fi
  DEBIAN_PASS=$(grep password /etc/mysql/debian.cnf | head -n 1 | cut -f3 -d ' ')
  echo "GRANT ALL ON *.* TO 'debian-sys-maint'@'%' IDENTIFIED BY '$DEBIAN_PASS' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -u\"$ADMIN_USER\" -p\"$ADMIN_PASSWORD\"
  killall mysqld
  sleep 10s
  echo "Set owner and group to current mysql user and group"
  chown -R mysql:mysql /var/lib/mysql
  chown -R mysql:mysql /var/log/mysql

  if [ ! -z ${DB_NAME+x} ] && [ ! -z ${DB_USER+x} ] && [ ! -z ${DB_PASSWORD+x} ]; then
    echo "Auto configuring db '$DB_NAME' with user '$DB_USER' and password '$DB_PASSWORD'"
    echo "CREATE DATABASE $DB_NAME;" | mysql -u\"$ADMIN_USER\" -p\"$ADMIN_PASSWORD\"
    echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" | mysql -u\"$ADMIN_USER\" -p\"$ADMIN_PASSWORD\"
    echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" | mysql -u\"$ADMIN_USER\" -p\"$ADMIN_PASSWORD\"
  fi
fi
echo "DB installed"