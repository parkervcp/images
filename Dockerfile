FROM ubuntu:18.04

MAINTAINER Bee, <itznya10@gmail.com>

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && apt-get -y install apt-utils curl software-properties-common locales git cmake \
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
RUN apt-get update && apt-get -y install dotnet-sdk-2.2

    # Crystal
RUN curl -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add -
RUN echo "deb https://dist.crystal-lang.org/apt crystal main" | tee /etc/apt/sources.list.d/crystal.list
RUN apt-get update && apt-get -y install crystal libssl-dev libxml2-dev libyaml-dev libgmp-dev libreadline-dev libz-dev

    # Composer & PHP7.2
RUN apt-get update && apt-get install -y php7.2 php7.2-cli php7.2-gd php7.2-pdo php7.2-mbstring php7.2-tokenizer php7.2-bcmath php7.2-xml php7.2-curl php7.2-zip && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get -y purge apache2*
    # Ruby
RUN apt-get update && apt-get -y install make ffmpeg g++ && apt -y install ruby ruby-dev libopus0 && gem install discordrb

    # Golang
RUN apt-get update && apt-get -y install golang && go get github.com/bwmarrin/discordgo

    # Java
RUN apt-get update && apt-get -y install openjdk-8-jdk openjdk-8-jre

    # Clojure
RUN apt-get update && apt-get -y install rlwrap build-essential
RUN curl -O https://download.clojure.org/install/linux-install-1.10.1.469.sh 
RUN chmod +x linux-install-1.10.1.469.sh && bash linux-install-1.10.1.469.sh

    # NodeJS
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install nodejs node-gyp \
    && npm install discord.js node-opus opusscript \
    && npm install sqlite3 --build-from-source

    # Python3
RUN apt-get update && apt-get -y install python3.7 python3-pip python2.7 python-pip libffi-dev mono-complete \
    && pip3 install aiohttp websockets pynacl opuslib \
    && python3 -m pip install -U discord.py[voice]
    
    # Lua5.1
RUN apt-get update && apt-get -y install lua5.1 m4 luarocks && luarocks install litcord

    # Luvit
RUN curl -fsSL https://github.com/luvit/lit/raw/master/get-lit.sh | sh
RUN mv luvit /usr/bin && mv luvi /usr/bin && mv lit /usr/bin

    # Scala
RUN apt-get update && apt-get -y install scala

    # Dlang
RUN apt-get update && apt-get -y install dub && dub fetch dscord

    # Rust
RUN apt-get update && apt-get -y install youtube-dl pkg-config rustc libsodium23

    # Swift
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true && apt-get -q update && \
    apt-get -q install -y \
    libatomic1 \
    libbsd0 \
    libcurl4 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libgcc-5-dev \
    libstdc++-5-dev \
    libpython2.7 \
    tzdata \
    git \
    pkg-config \
    && rm -r /var/lib/apt/lists/*
ARG SWIFT_PLATFORM=ubuntu18.04
ARG SWIFT_BRANCH=swift-5.0.3-release
ARG SWIFT_VERSION=swift-5.0.3-RELEASE
ENV SWIFT_PLATFORM=$SWIFT_PLATFORM \
    SWIFT_BRANCH=$SWIFT_BRANCH \
    SWIFT_VERSION=$SWIFT_VERSION
RUN SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/$SWIFT_VERSION/$SWIFT_VERSION-$SWIFT_PLATFORM.tar.gz \
    && apt-get update \
    && apt-get install -y curl \
    && curl -fSsL $SWIFT_URL -o swift.tar.gz \
    && curl -fSsL $SWIFT_URL.sig -o swift.tar.gz.sig \
    && apt-get -y autoremove \
    && export GNUPGHOME="$(mktemp -d)" \
    && set -e; \
        for key in \
      # pub   4096R/ED3D1561 2019-03-22 [expires: 2021-03-21]
      #       Key fingerprint = A62A E125 BBBF BB96 A6E0  42EC 925C C1CC ED3D 1561
      # uid                  Swift 5.x Release Signing Key <swift-infrastructure@swift.org          
          A62AE125BBBFBB96A6E042EC925CC1CCED3D1561 \
        ; do \
          gpg --quiet --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
        done \
    && gpg --batch --verify --quiet swift.tar.gz.sig swift.tar.gz \
    && tar -xzf swift.tar.gz --directory / --strip-components=1 \
    && rm -r "$GNUPGHOME" swift.tar.gz.sig swift.tar.gz \
    && chmod -R o+r /usr/lib/swift
RUN swift --version

    # Nim  
RUN curl https://nim-lang.org/choosenim/init.sh -sSf | bash -s -- -y
ENV PATH=/root/.nimble/bin:$PATH
RUN nimble install discordnim -y

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./bot.sh /bot.sh

CMD ["/bin/bash", "/bot.sh"]
