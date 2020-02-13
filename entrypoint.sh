#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# echo
echo -e ":/home/container$ ${startvariable}"


# Run the Server
LD_LIBRARY_PATH=.
LD_PRELOAD=${startvariable} ./bedrock_server
