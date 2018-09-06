FROM node:6-stretch

ENV MATRIX_IRC_BOTNAME=IRCBot

RUN set -x \
    && groupadd -r synapse --gid=999 \
    && useradd -r -g synapse --uid=999 --shell=/bin/false synapse \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       gettext-base \
    && npm install matrix-appservice-irc --global \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && mkdir -p /data /app-services \
    && chown -R synapse:synapse /data /app-services

ADD start.sh /start.sh

RUN set -x \
    && chmod +x start.sh

USER synapse

CMD ["/start.sh"]
