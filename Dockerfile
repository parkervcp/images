FROM        ubuntu:18.04

LABEL       author="mrkrabs" maintainer="bl4ckspr4y@protonmail.com"

RUN         dpkg --add-architecture i386 \
            && apt update \
            && apt upgrade -y \
            && apt install -y libstdc++6 lib32stdc++6 tar curl iproute2 openssl \
            && apt install -y libtbb2:i386 libtbb-dev:i386 \
            && useradd -d /home/container -m container

USER        container
ENV         USER=container HOME=/home/container

WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh

CMD         ["/bin/bash", "/entrypoint.sh"]
