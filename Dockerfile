# ----------------------------------
# Environment: debian:buster-slim
# Minimum Panel Version: 0.7.X
# ----------------------------------
FROM quay.io/parkervcp/pterodactyl-images:base_debian

LABEL author="CastBlacKing" maintainer="thewagaming@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

## update base packages
RUN apt update -y \
    && apt upgrade -y \
    && apt install -y wget sudo curl tar zip unzip sed apt-utils ca-certificates \
    && wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt update -y \  
    && apt install -y dotnet-sdk-5.0 aspnetcore-runtime-5.0 libgdiplus

## add container user
USER    container
RUN ln -s /home/container/ /nonexistent
ENV USER=container HOME=/home/container

## Installing Umod to use later
RUN dotnet tool update uMod --version "*-*" --global --add-source https://www.myget.org/f/umod/api/v3/index.json
RUN dotnet new -i "uMod.Templates::*-*" --nuget-source https://www.myget.org/f/umod/api/v3/index.json &>/dev/null

# Path to .profile
RUN export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 \
    && echo "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1; export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT" >> ~/.profile \
    && export PATH="$PATH:$HOME/.dotnet/tools" \
    && export PATH="$PATH:/home/container/.dotnet/tools" \ 
    && echo "PATH=\$PATH:\$HOME/.dotnet/tools; export PATH" >> ~/.profile \
    && ~/.dotnet/tools/umod complete --install

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
