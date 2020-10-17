# ----------------------------------
# Environment: debian:buster-slim
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM  quay.io/parkervcp/pterodactyl-images:base_debian

LABEL author="Michael Parker" maintainer="parker@pterodactyl.io"

##    update base packages
RUN   apt update \
 &&   apt upgrade -y

##    install dependencies
RUN   apt install -y ffmpeg curl
RUN   curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /bin/sh/youtube-dl
RUN   chmod a+rx /bin/sh/youtube-dl

COPY  ./entrypoint.sh /entrypoint.sh
CMD   ["/bin/bash", "/entrypoint.sh"]
