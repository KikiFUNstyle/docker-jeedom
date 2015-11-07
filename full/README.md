# Description

Cette image est basé sur php7 + apache + mysql et jeedom 2.0. Il est recommandé de ne pas mettre à jour jeedom tant que jeedom 2.0 ne sera pas sortie.

A la difference de l'image normal cette image inclus mysql


# Variables d'environement

ROOT_PASSWORD : mot de passe root SSH. Optionnel si non précisé le mot de passe sera jeedom. Il est cepedant fortement recommandé de le renseigner


# Droits

Il faut lancer le conteneur en mode privilège pour que celui-ci puisse acceder au périphérique (enOcena, Zwave, Edisio....)


# Accès au préripherique USB

Pour que jeedom puisse accèder à tous les périphérique USB il faut les monter dans le conteneur
````
-v /dev/tty*:/dev

````


# Volume de données

Pour pouvoir mettre à jour facilement le conteneur sans impact sur les données stockée il faut séparer les répertoires de données : 
````
-v /my/jeedom/data/html:/var/html/www
-v /my/jeedom/data/mysql:/var/lib/mysql

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

docker run --name some-jeedom --privileged -v /dev/tty*:/dev -v /my/jeedom/data/html:/var/html/www -v /my/jeedom/data/mysql:/var/lib/mysql -e ROOT_PASSWORD=todo -p 9080:80 -p 9022:22 jeedom/jeedom-full

Votre jeedom sera accessible en faisant IP_CONTENEUR:9080