FROM node:10-buster-slim

ARG MATRIX_IRC_TAG=0.13.1

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
       git \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch "$MATRIX_IRC_TAG" https://github.com/matrix-org/matrix-appservice-irc.git \
    && cd matrix-appservice-irc \
    && npm install --global

ADD start.sh /start.sh

RUN set -x \
    && chmod +x start.sh

USER synapse

CMD ["/start.sh"]
