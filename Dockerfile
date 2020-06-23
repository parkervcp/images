# ----------------------------------
# Environment: ubuntu
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM        debian:stable-slim

LABEL       author="Dex's Lab" maintainer="dex35803@gmail.com"

ENV         DEBIAN_FRONTEND noninteractive

RUN         apt update -y \
    && apt upgrade \
    && apt install -y zip unzip wget curl iproute2 libatomic1 libsdl2-2.0-0 binutils xz-utils libfontconfig liblzo2-2 libicu63 youtube-dl ffmpeg libunwind8 icu-devtools libssl-dev lib32gcc1 sqlite3 libsqlite3-dev apt-transport-https \
    && useradd -d /home/container -m container \
    && wget https://packages.microsoft.com/config/ubuntu/19.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt update -y \
    && apt install -y dotnet-sdk-3.1


USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
