#!/bin/bash
#!/usr/bin/env node

cd /opt/iobroker
iobroker install zigbee
iobroker add zigbee

iobroker install node-red
iobroker add node-red

iobroker install mqtt
iobroker add mqtt

iobroker install sql
iobroker add sql

iobroker install deconz
iobroker add deconz

npm install iobroker.material

exit 0