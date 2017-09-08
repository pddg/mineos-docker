FROM debian:jessie
LABEL maintainer "pudding <pudding@mail.poyo.info>"

ENV TZ Asia/Tokyo
COPY entrypoint.sh /entrypoint.sh

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list \
    && echo ${TZ} > /etc/timezone \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime

RUN apt-get update && apt-get install -y \
    supervisor \
    rdiff-backup \
    screen \
    rsync \
    git \
    curl \
    rlwrap \
    && apt-get install -y -t jessie-backports openjdk-8-jre-headless ca-certificates-java \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl https://deb.nodesource.com/node_4.x/pool/main/n/nodejs/nodejs_4.6.2-1nodesource1~jessie1_amd64.deb > node.deb \
    && dpkg -i node.deb \
    && rm node.deb

RUN mkdir /usr/games/minecraft \
    && cd /usr/games/minecraft \
    && git clone --depth=1 https://github.com/hexparrot/mineos-node.git . \
    && cp mineos.conf /etc/mineos.conf \
    && chmod +x webui.js mineos_console.js service.js

RUN cd /usr/games/minecraft \
    && apt-get update \
    && apt-get install -y build-essential \
    && npm install \
    && apt-get remove --purge -y build-essential \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cp /usr/games/minecraft/init/supervisor_conf /etc/supervisor/conf.d/mineos.conf \
    && chmod +x /entrypoint.sh

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8443 25565-25570
