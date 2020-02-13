#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Replace Startup Variables
MODIFIED_STARTUP=$(echo $(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
START_COMMAND=$(echo -e ${MODIFIED_STARTUP})
echo -e ":/home/container$ ${START_COMMAND}"

#Test
export LD_PRELOAD=./preload.so
export LD_LIBRARY_PATH=.

# Run the Server
LD_LIBRARY_PATH=.
LD_PRELOAD=./preload.so ./bedrock_server
${MODIFIED_STARTUP}
