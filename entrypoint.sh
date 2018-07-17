#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Update Source Server
if [ ! -z ${SRCDS_APPID} ]; then
    ./steamcmd/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update ${SRCDS_APPID} +quit
fi

## Replace Startup Variables
MODIFIED_STARTUP=`echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'`
# echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
./7DaysToDieServer.x86_64 -configfile=serverconfig.xml -quit -batchmode -nographics -dedicated ${MODIFIED_STARTUP} -logfile logs/latest.log & sleep 15 && telnet -E 127.0.0.1 8081
