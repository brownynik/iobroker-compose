#!/bin/sh

CFG_FOLDER=/mnt/hdd

DB_VOLUME_FOLDER=$CFG_FOLDER/mariadb
DB_STARTUP_FOLDER=$CFG_FOLDER/mariadb/startup
MOSQUITTO_VOLUME_FOLDER=$CFG_FOLDER/mosquitto
IOBROKER_VOLUME_FOLDER=$CFG_FOLDER/iobroker
IOBROKER_STARTUP_FOLDER=$CFG_FOLDER/iobroker-startup
PORTAINER_FOLDER=$CFG_FOLDER/portainer
DECONZ_FOLDER=$CFG_FOLDER/deconz

mkdir -p $DB_VOLUME_FOLDER/etc && cp -fa $CFG_FOLDER/configs/mariadb/*.cnf $DB_VOLUME_FOLDER/etc
mkdir -p $DB_STARTUP_FOLDER

# If there are files corresponding to the mask, copy them
find $CFG_FOLDER/configs/mariadb -type f -name "*.sql" -exec cp -fa $CFG_FOLDER/configs/mariadb/*.sql $DB_STARTUP_FOLDER \;
find $CFG_FOLDER/configs/mariadb -type f -name "*.sh" -exec cp -fa $CFG_FOLDER/configs/mariadb/*.sh $DB_STARTUP_FOLDER \;

mkdir -p $MOSQUITTO_VOLUME_FOLDER/config
mkdir $MOSQUITTO_VOLUME_FOLDER/data
mkdir $MOSQUITTO_VOLUME_FOLDER/log
rm -fr $MOSQUITTO_VOLUME_FOLDER/config && cp -fr $CFG_FOLDER/configs/mosquitto $MOSQUITTO_VOLUME_FOLDER/config
#touch $MOSQUITTO_VOLUME_FOLDER/config/mosquitto.conf
touch $MOSQUITTO_VOLUME_FOLDER/config/passwd
touch $MOSQUITTO_VOLUME_FOLDER/log/mosquitto.log
chmod 0666 $MOSQUITTO_VOLUME_FOLDER/log/mosquitto.log
#chown 1883:1883 -R $MOSQUITTO_VOLUME_FOLDER


#mkdir -p $IOBROKER_VOLUME_FOLDER/postinstall
#rm -fr $IOBROKER_VOLUME_FOLDER/postinstall && cp -fr $CFG_FOLDER/configs/iobroker $IOBROKER_VOLUME_FOLDER/postinstall

mkdir -p $IOBROKER_STARTUP_FOLDER
rm -fr $IOBROKER_STARTUP_FOLDER && cp -fr $CFG_FOLDER/configs/iobroker $IOBROKER_STARTUP_FOLDER

export DB_VOLUME_FOLDER
export DB_STARTUP_FOLDER
export MOSQUITTO_VOLUME_FOLDER
export IOBROKER_VOLUME_FOLDER
export IOBROKER_STARTUP_FOLDER
export DECONZ_FOLDER
export CFG_FOLDER

docker network create \
--driver=bridge \
--attachable \
  iobroker-network

#--subnet=192.168.32.0/20 \
#--ip-range=192.168.32.0/20 \
#--gateway=192.168.32.1 \
#--attachable \
#  iobroker-network


docker-compose -f $CFG_FOLDER/iobroker-compose.yaml -p iot-broker up -d

# Генерируем пароль для MOSQUITTO. ToDo: перенести в entrypoint скрипт.
docker exec -it mosquitto mosquitto_passwd -b /mosquitto/config/passwd mqttlogin mqttpassword
docker exec -it mosquitto chmod 0666 -R /mosquitto/data

# переехало в entrypoint скрипт
#docker exec -it iobroker sed -i 's/,ru:"Драйвера",/,ru:"Драйверы",/' $IOBROKER_VOLUME_FOLDER/node_modules/iobroker.admin/www/js/app.js
#docker exec -it iobroker sed -i 's/\\"Драйвера\\"/\\"Драйверы\\"/' $IOBROKER_VOLUME_FOLDER/node_modules/iobroker.admin/www/js/app.js.map

