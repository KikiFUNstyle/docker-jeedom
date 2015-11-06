#/bin/bash

## FUNCTIONS

function exit_if_no_credentials_provided {
  if [ "yes" != "$CREDENTIALS_PROVIDED" ]
  then
    >&2 echo ">> you need credentials for this action but no credentials were provided!";
    exit 1
  fi
}

function init_db {
  mysql_install_db

  /usr/bin/mysqld_safe &
  sleep 10s

  echo "GRANT ALL ON *.* TO $ADMIN_USER@'%' IDENTIFIED BY '$ADMIN_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql

  killall mysqld
  sleep 10s
}

## MAIN

# variables stuff
MY_IP=`ip a s eth0 | grep inet | awk '{print $2}' | sed 's/\/.*//g' | head -n1`

CREDENTIALS_PROVIDED="yes"
if [ -z ${ADMIN_USER+x} ]
then
  >&2 echo ">> no \$ADMIN_USER specified"
  ADMIN_USER="\$ADMIN_USER"
  CREDENTIALS_PROVIDED="no"
fi
if [ -z ${ADMIN_PASSWORD+x} ]
then
  >&2 echo ">> no \$ADMIN_PASSWORD specified"
  CREDENTIALS_PROVIDED="no"
fi

# mysql daemon stuff
if [ -z ${BIND_ADDRESS+x} ]
then
  BIND_ADDRESS="0.0.0.0"
fi
echo ">> bind mysql daemon to $BIND_ADDRESS"
sed -i -e "s/^bind-address\s*=\s*127.0.0.1/bind-address = $BIND_ADDRESS/" /etc/mysql/my.cnf

echo ">> disable dns resolution for mysql (speeds it up)"
sed -i 's/\[mysqld\]/&\nskip-host-cache\nskip-name-resolve/g' /etc/mysql/my.cnf

if [ ! -f /var/lib/mysql/ibdata1 ]; then
  echo ">> init db"
  exit_if_no_credentials_provided
  init_db
fi
echo ">> db installed"

echo ">> set owner and group to current mysql user and group"
chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/log/mysql

# auto create db with user...
if [ ! -z ${DB_NAME+x} ] && [ ! -z ${DB_USER+x} ] && [ ! -z ${DB_PASSWORD+x} ]
then
  echo ">> auto configuring db '$DB_NAME' with user '$DB_USER' and password '<hidden>'"
  exit_if_no_credentials_provided

  echo "CREATE DATABASE $DB_NAME;" > /tmp/autocreatedb.mysql
  echo "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';" >> /tmp/autocreatedb.mysql
  echo "GRANT USAGE ON *.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD' REQUIRE NONE WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;" >> /tmp/autocreatedb.mysql
  echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';" >> /tmp/autocreatedb.mysql

  bash -c "sleep 3; mysql -u\"$ADMIN_USER\" -p\"$ADMIN_PASSWORD\" < /tmp/autocreatedb.mysql && echo '>> db '$DB_NAME' successfully installed'; rm /tmp/autocreatedb.mysql" &
fi