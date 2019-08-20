
FROM ubuntu:18.04

MAINTAINER Kitty, <sebastiannicolaelazar@gmail.com>

RUN apt update \
    && apt upgrade -y \
    && apt autoremove -y \
    && apt autoclean \
    && apt -y install curl software-properties-common locales git cmake \
    && useradd -d /home/container -m container

    # Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

    # Dotnet
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys EB3E94ADBE1229CF 
RUN apt-key adv --keyserver packages.microsoft.com --recv-keys 52E16F86FEE04B979B07E28DB02C46DF417A0893 
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-bionic-prod bionic main" > /etc/apt/sources.list.d/dotnetdev.list' 
RUN apt update && apt -y install dotnet-sdk-2.2

    # Crystal
RUN curl -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add -
RUN echo "deb https://dist.crystal-lang.org/apt crystal main" | tee /etc/apt/sources.list.d/crystal.list
RUN apt update && apt -y install crystal && apt -y install libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev libz-dev

    # Lua5.1
RUN apt -y install lua5.1 m4 luarocks && luarocks install litcord

    # Composer & PHP7.2
RUN apt update
RUN apt install -y php7.2 php7.2-cli php7.2-gd php7.2-pdo php7.2-mbstring php7.2-tokenizer php7.2-bcmath php7.2-xml php7.2-curl php7.2-zip && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

    # Ruby
RUN apt -y install make g++ && apt -y install ruby ruby-dev libopus0 && gem install discordrb && apt update && apt -y install ffmpeg

    # Golang
RUN apt -y install golang && go get github.com/bwmarrin/discordgo

    # Java
RUN apt -y install openjdk-8-jdk maven gradle

    # NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt update \
    && apt -y upgrade \
    && apt -y install nodejs node-gyp \
    && npm install discord.js node-opus opusscript \
    && npm install sqlite3 --build-from-source
RUN apt -y install build-essential && apt -y install g++ && npm install discord.io && npm install --no-optional eris && npm install discordie

    # Python3
RUN apt -y install python3.6 python3-pip python2.7 python-pip libffi-dev mono-complete \
    && pip3 install aiohttp websockets pynacl opuslib \
    && python3 -m pip install -U discord.py[voice]

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
