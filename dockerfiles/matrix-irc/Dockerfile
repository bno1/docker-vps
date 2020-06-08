FROM node:14-buster-slim

ARG MATRIX_IRC_TAG=0.17.1

ENV MATRIX_IRC_BOTNAME=IRCBot

RUN set -x \
    && groupadd -r synapse --gid=999 \
    && useradd -r -m -g synapse --uid=999 --shell=/bin/false synapse \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       gettext-base \
       git \
       python \
       python3 \
       build-essential \
       libicu-dev \
       git \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*

USER synapse
WORKDIR /home/synapse

RUN set -x \
    && mkdir matrix-appservice-irc \
    && git clone --branch "$MATRIX_IRC_TAG" \
       https://github.com/matrix-org/matrix-appservice-irc.git \
       matrix-appservice-irc \
    && cd matrix-appservice-irc \
    && npm install

ADD --chown=synapse:synapse start.sh start.sh

RUN set -x \
    && chmod +x start.sh

ENTRYPOINT []
CMD ["./start.sh"]
