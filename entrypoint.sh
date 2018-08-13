#!/bin/bash
cd /home/container

# Output Current Python Version
python --version

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# Install Python requirements
if [ -d Red-DiscordBot ]; then
  cd /home/container/Red-DiscordBot
  python3 launcher.py --update-red
fi

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
