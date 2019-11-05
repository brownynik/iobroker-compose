# iobroker-compose
This is a personalized service configuration.
The configuration includes the MariaDB database, MQTT broker Mosquitto, the web interface deCONZ (Phoscon App) and an ioBroker installation with a predefined set of modules.

Полезные подстрочники "на каждый день":

Запустить bash в контейнере (container_name) mariadb:
docker exec -it mariadb bash

Посмотреть логи:
docker logs mariadb

