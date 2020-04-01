FROM debian:10.1-slim

RUN apt-get update \
    && apt-get -y install apt-utils curl software-properties-common apt-transport-https ca-certificates wget dirmngr gnupg iproute2 locales \
    && useradd -d /home/container -m container

    # Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "deb https://download.rethinkdb.com/apt `lsb_release -cs` main" | tee /etc/apt/sources.list.d/rethinkdb.list  \
    && wget -qO- https://download.rethinkdb.com/apt/pubkey.gpg | apt-key add -  \
    && apt-get update && apt-get install -y rethinkdb

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
