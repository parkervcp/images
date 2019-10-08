# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Source Engine
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM        ubuntu:18.04

LABEL       author="Pterodactyl Software" maintainer="support@pterodactyl.io"

ENV         DEBIAN_FRONTEND noninteractive
# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y tar curl gcc g++ lib32gcc1 libgcc1 libcurl4-gnutls-dev:i386 libcurl4:i386 lib32tinfo5 libtinfo5:i386 lib32z1 libstdc++6 lib32stdc++6 libncurses5:i386 libcurl3-gnutls:i386 libreadline5 libncursesw5 lib32ncursesw5 iproute2 gdb libsdl1.2debian libfontconfig telnet net-tools netcat libtcmalloc-minimal4:i386 \
            && curl http://ftp.pbone.net/mirror/www.startcom.org/AS-5.0.0/updates/i386/compat-libstdc++-33-3.2.3-61.i386.rpm \
            && rpm -ihw --nodeps compat-libstdc++-33-3.2.3-61.i386.rpm
            && useradd -m -d /home/container container

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
