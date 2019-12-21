#!/bin/bash
#!/usr/bin/env node

cd /opt/iobroker

installadapters=()
installadapters+=('javascript')
installadapters+=('sql')
installadapters+=('node-red')
installadapters+=('mqtt')

#installadapters+=('zwave')
installadapters+=('deconz')
installadapters+=('zigbee')
installadapters+=('broadlink2')
installadapters+=('mihome')


installadaptersnode=()
installadaptersnode+=('material')


adapters=()
adapters=($(iobroker list adapters | awk -F'adapter.' '{print $2;}'|awk -F' ' '{print $1;}'))

for a in "${installadaptersnode[@]}"; do
  ix=$( printf "%s\n" "${adapters[@]}"| grep "^${a}$" )
  if [[ -z $ix ]]
    then
      echo "Install ${a} adapter, npm mode."
      npm install iobroker.${a}
  fi
done


for a in "${installadapters[@]}"; do
  ix=$( printf "%s\n" "${adapters[@]}"| grep "^${a}$" )
  if [[ -z $ix ]]
    then
      echo "Install ${a} adapter."
      iobroker install ${a}
      iobroker add ${a}
      if [ ${a} = "node-red" ]
	then
	  sudo -H -u iobroker npm install --unsafe-perm git+https://github.com/brownynik/node-red-contrib-xiaomi-devices.git
	  #npm install github:brownynik/node-red-contrib-xiaomi-devices
	  npm install node-red-contrib-light-scheduler
	  npm install node-red-contrib-squeezebox
	  #npm install node-red-contrib-polymer
	  npm install node-red-node-mysql
      fi
  fi
done






exit 0
