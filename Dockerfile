# ----------------------------------
# Environment: ubuntu
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM        ubuntu:18.04

LABEL       author="Michael Parker" maintainer="parker@pterodactyl.io"

ENV         DEBIAN_FRONTEND noninteractive

RUN         apt -y update \
            && apt -y upgrade \
            && apt install -y zip unzip wget curl libssl1.1 iproute2 fontconfig libsdl1.2debian liblzo2-2 libiculx60 libjansson4 libzip-dev libsdl2-2.0-0 \
            && useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
