#!/bin/bash
cd /home/container

# This entrypoint.sh is a modification of the entrypoint made by: Software-Noob, to him credit for making differential Auto-Update scheme.

# Exporting: Dotnet Path / Library Path (Umod error prevent)
export PATH="$PATH:$HOME/.dotnet/tools"
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

## Update Game and uMod
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

# AutoUpdate All
if [[ ${AUTO_UPDATE} == "1" ]] && [[ ${UPDATE_PLUGINS} == "0" ]]; then
    echo -e "STARTUP: Updating game and uMod, ignoring plugin updates as update plugins is set to 0..."
    umod update -P game core apps extensions --patch-available --strict
    echo -e "STARTUP: Game server and uMod update is complete!"
fi

# AutoUpdate Plugins
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

# AutoUpdate Not Update Notice
if [[ ${AUTO_UPDATE} == "0" ]] && [[ ${UPDATE_PLUGINS} == "0" ]]; then
    echo "STARTUP: Not performing any updates as auto-update is set to 0 (disabled). Starting Server"
fi

# Installing Plugins
if [[ ! -z ${INSTALL_PLUGINS} ]]; then
    echo -e "STARTUP: Found configured Plugins, installing Plugins: ${INSTALL_PLUGINS}"
    umod require ${INSTALL_PLUGINS} 
    echo -e "STARTUP: Plugin installation is completed!"
fi


# Cleanup non-required startups
if [ -f start_server.sh ]; then
rm umod-install.sh start_server.sh start_server_xterm.sh launcher.sh
rm "Valheim Dedicated Server Manual.pdf"
fi

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
eval ${MODIFIED_STARTUP}