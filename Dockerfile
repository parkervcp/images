FROM        ubuntu:20.04

LABEL       author="Pterodactyl Software" maintainer="support@pterodactyl.io"
ENV         DEBIAN_FRONTEND noninteractive
ENV         USER_NAME container
ENV         NSS_WRAPPER_PASSWD /tmp/passwd 
ENV         NSS_WRAPPER_GROUP /tmp/group

# Install Dependencies
RUN         dpkg --add-architecture i386 \
            && apt-get update \
            && apt-get upgrade -y \
            && apt-get install -y libgcc-10-dev libstdc++-10-dev libtinfo5 lib64z1 libcurl3-gnutls \
            && apt-get install -y libnss-wrapper gettext-base tar curl gcc g++ libc6 libtbb2 lib32z1 lib32gcc1 lib32stdc++6 libsdl2-2.0-0 libsdl2-2.0-0:i386 libtbb2:i386 lib32stdc++6 libtinfo5:i386 libncurses5:i386 libcurl3-gnutls:i386 \
            && useradd -m -d /home/container -s /bin/bash container \
            && touch ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP} \
            && chgrp 0 ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP} \
            && chmod g+rw ${NSS_WRAPPER_PASSWD} ${NSS_WRAPPER_GROUP}

ADD         passwd.template /passwd.template

USER        container
ENV         HOME /home/container
WORKDIR     /home/container

COPY        ./libnss_wrapper.so /libnss_wrapper.so
COPY        ./libnss_wrapper_x64.so /libnss_wrapper_x64.so
COPY        ./entrypoint.sh /entrypoint.sh
CMD         ["/bin/bash", "/entrypoint.sh"]
