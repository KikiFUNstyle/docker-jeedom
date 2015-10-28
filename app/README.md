# Environment Variables
MYSQL_JEEDOM_PASSWORD
MYSQL_HOST
MYSQL_PORT
MYSQL_JEEDOM_USER
MYSQL_JEEDOM_DBNAME

docker run --name some-jeedom --privileged -v /my/jeedom/data:/var/html/www -e MYSQL_JEEDOM_PASSWORD=todo -e MYSQL_HOST=todo -e MYSQL_PORT=todo -e MYSQL_JEEDOM_USER=todo -e MYSQL_JEEDOM_DBNAME=todo -p 80:9080 -p 22:9022 jeedom/docker