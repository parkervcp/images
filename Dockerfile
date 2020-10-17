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
RUN   apt install -y ffmpeg python3-pip
RUN   pip install --upgrade youtube_dl

COPY  ./entrypoint.sh /entrypoint.sh
CMD   ["/bin/bash", "/entrypoint.sh"]
