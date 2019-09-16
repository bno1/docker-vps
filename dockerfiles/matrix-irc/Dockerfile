FROM node:10-buster-slim

ENV MATRIX_IRC_BOTNAME=IRCBot

RUN set -x \
    && groupadd -r synapse --gid=999 \
    && useradd -r -g synapse --uid=999 --shell=/bin/false synapse \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       gettext-base \
       git \
       python \
       python3 \
       build-essential \
       libicu-dev \
    && npm install matrix-appservice-irc --global --unsafe \
    && rm -rf /var/lib/apt/lists/*

ADD start.sh /start.sh

RUN set -x \
    && chmod +x start.sh

USER synapse

CMD ["/start.sh"]
