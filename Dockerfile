# ----------------------------------
FROM        ubuntu:18.04

MAINTAINER  Nils S. <nilsansa@gmail.com>

# Install Dependencies
RUN         apt update && \
            apt upgrade -y && \
            apt -y install adduser init-system-helpers libc6 libcurl3-gnutls libgcc1 libgcc1 libjsoncpp1 libleveldb1v5 liblua5.1-0 libluajit-5.1-2 libsqlite3-0 libstdc++6 zlib1g && \
            apt clean && \
            useradd -d /home/container -m container && \
            cd /home/container

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
