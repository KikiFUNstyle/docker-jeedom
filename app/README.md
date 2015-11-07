# Description

Ce docker contient une image de jeedom sans base de donnée il vous faut donc un autre docker hebergeant une base de donnée mysql. Il vous faudra au préalable creer une base de données et un utilisateur ayant tous les droits dessus.

Cette image est basé sur php7 + apache et jeedom 2.0. Il est recommandé de ne pas mettre à jour jeedom tant que jeedom 2.0 ne sera pas sortie.


# Variables d'environement

MYSQL_JEEDOM_PASSWORD : mot de passe de la base de données
MYSQL_HOST : ip de l'hote de la base de données
MYSQL_PORT : port de la base de données
MYSQL_JEEDOM_USER : utilisateur pour la base de données
MYSQL_JEEDOM_DBNAME : nom de la base de données
ROOT_PASSWORD : mot de passe root SSH. Optionnel si non précisé le mot de passe sera jeedom. Il est cepedant fortement recommandé de le renseigner


# Droits

Il faut lancer le conteneur en mode privilège pour que celui-ci puisse acceder au périphérique (enOcena, Zwave, Edisio....)


# Accès au préripherique USB

Pour que jeedom puisse accèder à tous les périphérique USB il faut les monter dans le conteneur
````
-v /dev/tty*:/dev

````


# Volume de données

Pour pouvoir mettre à jour facilement le conteneur sans impact sur les données stockée il faut séparer le répertoire de données : 
````
-v /my/jeedom/data:/var/html/www

````


# Ports

Il faut rediriger certain port du contenaire vers l'hote pour y avoir accès. Il faut obligatoire rediriger le port 80. Les ports suivants sont facultatifs :
22 : SSH
17100 : zibasdom
10000 : orvibo
1886 : MQTT
162 : SNMP
4025 : DSC


# Exemple de ligne de commande

docker run --name some-jeedom --privileged -v /dev/tty*:/dev -v /my/jeedom/data:/var/html/www -e ROOT_PASSWORD=todo -e MYSQL_JEEDOM_PASSWORD=todo -e MYSQL_HOST=todo -e MYSQL_PORT=todo -e MYSQL_JEEDOM_USER=todo -e MYSQL_JEEDOM_DBNAME=todo -p 9080:80 -p 9022:22 jeedom/jeedom

Votre jeedom sera accessible en faisant IP_CONTENEUR:9080