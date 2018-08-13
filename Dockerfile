# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Python
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM    python:3.6-alpine

LABEL   author="Martin Friesenbichler" maintainer="friesi@srvb.at"

RUN     apk update \
        && apk upgrade \
        && apk add --no-cache --update curl ca-certificates openssl git tar bash sqlite python3-dev ffmpeg opus-dev libffi-dev libsodium-dev g++ make \
        && adduser -D -h /home/container container \
        && curl -o req.txt https://raw.githubusercontent.com/Cog-Creators/Red-DiscordBot/develop/requirements.txt \
        && pip install -r req.txt

USER    container
ENV     USER=container HOME=/home/container

WORKDIR /home/container

COPY    ./entrypoint.sh /entrypoint.sh

CMD     ["/bin/bash", "/entrypoint.sh"]
