# ----------------------------------
# Environment: debian:buster-slim
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM debian:buster-slim

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"

ENV DEBIAN_FRONTEND noninteractive

## add container user
RUN useradd -m -d /home/container -s /bin/bash container

## update base packages
RUN apt update \
 && apt upgrade -y

## install dependencies
RUN apt install -y gcc g++ libgcc1 lib32gcc1 gdb libc6 git wget curl tar zip unzip binutils xz-utils liblzo2-2 iproute2 net-tools netcat telnet libatomic1 libsdl1.2debian libsdl2-2.0-0 \
    libfontconfig libicu63 icu-devtools libunwind8 libssl-dev sqlite3 libsqlite3-dev libmariadbclient-dev locales ffmpeg youtube-dl

## configure locale
RUN update-locale lang=en_US.UTF-8 \
 && dpkg-reconfigure --frontend noninteractive locales

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
