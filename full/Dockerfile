FROM jeedom/jeedom

MAINTAINER loic@jeedom.com

RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

RUN apt-get update; apt-get install -y \
    mysql-server \
    mysql-client

RUN rm -rf /var/lib/mysql/ib*

ADD initdb.sh /root/initdb.sh
RUN chmod +x /root/initdb.sh
ADD init.sh /root/init.sh
RUN chmod +x /root/init.sh

CMD ["/root/init.sh"]

EXPOSE 22 80 162 1886 4025 17100 10000 

#17100 : zibasdom
#10000 : orvibo
#1886 : MQTT
#162 : SNMP
#4025 : DSC
