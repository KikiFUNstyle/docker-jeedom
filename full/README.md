# Environment Variables
MYSQL_JEEDOM_PASSWORD
MYSQL_HOST
MYSQL_PORT
MYSQL_JEEDOM_USER
MYSQL_JEEDOM_DBNAME

docker run --name some-jeedom --privileged -v /my/jeedom/data:/var/html/www -p 9180:80 -p 9122:22 jeedom/jeedom-full