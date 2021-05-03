#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route | awk '/default/ { print $3 }'`

# check if the game files are mounted
if [ ! -d ${GAME_FILE_PATH} ]; then
	echo "CoD 4 game files not found. Maybe they are not mounted?"
	echo "In order for the server to start mount the game files here: ${GAME_FILE_PATH}"
	while true; do sleep 2; done
else
	# Replace Startup Variables
	MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
	echo ":/home/container$ ${MODIFIED_STARTUP}"

	# Run the Server
	eval ${MODIFIED_STARTUP}
fi