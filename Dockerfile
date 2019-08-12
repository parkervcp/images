
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

    # Composer & PHP7.2
RUN apt update
RUN apt install -y php7.2 php7.2-cli php7.2-gd php7.2-pdo php7.2-mbstring php7.2-tokenizer php7.2-bcmath php7.2-xml php7.2-curl php7.2-zip 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

    # Ruby
RUN apt -y install make g++
RUN apt -y install ruby ruby-dev libopus0
RUN gem install discordrb
RUN apt update
RUN apt -y install ffmpeg

    # Golang
RUN apt -y install golang
RUN go get github.com/bwmarrin/discordgo

    # Java
RUN apt -y install openjdk-8-jdk maven gradle

    # NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt update \
    && apt -y upgrade \
    && apt -y install nodejs node-gyp \
    && npm install discord.js node-opus opusscript \
    && npm install sqlite3 --build-from-source

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
