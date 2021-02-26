#!/bin/bash
cd /home/container
sleep 1

# Make internal Docker IP address available to processes.
export INTERNAL_IP=`ip route get 1 | awk '{print $NF;exit}'`

# dotnet magic
export PATH="$PATH:$HOME/.dotnet/tools"
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1

# Check if launcher exists, if not then create one
if [ ! -f valheim_server.x86_64 ]; then
    echo "STARTUP:Launcher does not exist, creating new one..."
    umod new launcher valheim -P --force
fi

# Update Valheim and uMod
if [[ ${AUTO_UPDATE} == "1" ]] && [[ ${UPDATE_PLUGINS} == "1" ]]; then
        if [[ ! -z ${INSTALL_PLUGINS} ]]; then
        echo -e "STARTUP: Plugins configured, installing Plugins: ${INSTALL_PLUGINS}"
        umod require ${INSTALL_PLUGINS} 
        echo -e "STARTUP: Plugin installation is completed!"
        fi
    echo -e "STARTUP: Checking for game and plugins updates..."
    umod update -P all --patch-available
    echo -e "STARTUP: Game server and uMod update is complete!"
fi

if [[ ${AUTO_UPDATE} == "1" ]] && [[ ${UPDATE_PLUGINS} == "0" ]]; then
    echo -e "STARTUP: Updating game and uMod, ignoring plugin updates as update plugins is set to 0..."
    umod update -P game core apps extensions --patch-available
    #umod update core apps extensions --patch-available --strict --validate --prerelease
    echo -e "STARTUP: Game server and uMod update is complete!"
fi

if [[ ${AUTO_UPDATE} == "0" ]] && [[ ${UPDATE_PLUGINS} == "1" ]]; then
    if [[ ! -z ${INSTALL_PLUGINS} ]]; then
    echo -e "STARTUP: Found configured Plugins, checking if they are not installed: ${INSTALL_PLUGINS}"
    umod require ${INSTALL_PLUGINS} 
    echo -e "STARTUP: Plugin installation is completed!"
    fi
    echo -e "STARTUP: Updating plugins, ignoring game and uMod updates as auto update is set to 0..."
    umod update plugins
    echo -e "STARTUP: Plugin updates are completed!"
fi

if [[ ${AUTO_UPDATE} == "0" ]] && [[ ${UPDATE_PLUGINS} == "0" ]]; then
    echo "STARTUP: Not performing any updates as auto-update is set to 0 (disabled). Starting Server"
fi

if [[ ! -z ${INSTALL_PLUGINS} ]]; then
    echo -e "STARTUP: Found configured Plugins, installing Plugins: ${INSTALL_PLUGINS}"
    umod require ${INSTALL_PLUGINS} 
    echo -e "STARTUP: Plugin installation is completed!"
fi

if [ -f start_server.sh ]; then
rm umod-install.sh start_server.sh start_server_xterm.sh launcher.sh
rm "Valheim Dedicated Server Manual.pdf"
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}
