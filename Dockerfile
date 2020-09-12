# ----------------------------------
# Environment: debian 10
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM    mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base

LABEL   author="gOOvER" maintainer="info@goover.de"

ENV     DEBIAN_FRONTEND noninteractive

RUN     apt update -y \
        && apt upgrade -y \
        && apt install -y libgdiplus iproute2


USER    container
ENV     USER=container HOME=/home/container
WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh
CMD     ["/bin/bash", "/entrypoint.sh"]
