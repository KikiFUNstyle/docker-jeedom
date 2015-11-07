#/bin/bash
if [ ! -d /var/lib/mysql/mysql ]; then
  killall mysqld
  service mysql stop
  echo "Install DB"
  set -- mysqld "$@"
  DATADIR="$("$@" --verbose --help --log-bin-index=/tmp/tmp.index 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"
  echo 'Running mysql_install_db'
  mysql_install_db --user=mysql --datadir="$DATADIR" --rpm
  echo 'Finished mysql_install_db'
  service mysql start
  /usr/bin/mysqladmin -u root password ${ADMIN_PASSWORD}
  DEBIAN_PASS=$(grep password /etc/mysql/debian.cnf | head -n 1 | cut -f3 -d ' ')
  echo "GRANT ALL ON *.* TO 'debian-sys-maint'@'%' IDENTIFIED BY '$DEBIAN_PASS' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql -uroot -p${ADMIN_PASSWORD}
  service mysql stop
  killall mysqld
  rm /var/lib/mysql/ib*
fi

if [ ! -d /var/lib/mysql/ibdata1 ]; then
  echo "Init DB"
  rm /var/lib/mysql/ib*
  service mysql start
  if [ ! -z ${DB_NAME+x} ] && [ ! -z ${DB_USER+x} ] && [ ! -z ${DB_PASSWORD+x} ]; then
    echo "Auto configuring db '$DB_NAME' with user '$DB_USER' and password '$DB_PASSWORD'"
    echo "CREATE DATABASE $DB_NAME;" | mysql -uroot -p${ADMIN_PASSWORD}
    echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" | mysql -uroot -p${ADMIN_PASSWORD}
    echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" | mysql -uroot -p${ADMIN_PASSWORD}
  fi
fi
echo "DB installed"