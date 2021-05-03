FROM debian:buster-slim

LABEL author="grimsi" maintainer="admin@grimsi.de"

RUN apt-get update && \
    apt-get install -y \
            lib32stdc++6 \
            ca-certificates \
            iproute2 \
    && rm -rf /var/lib/apt/lists/*

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
