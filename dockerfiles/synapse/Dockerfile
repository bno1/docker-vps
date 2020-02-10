FROM debian:buster-slim

ARG SYNAPSE_TAG=v1.9.1
ARG SYNAPSE_HOST=example.org

RUN set -x \
    && groupadd -r synapse --gid=999 \
    && useradd -r -g synapse --uid=999 --shell=/bin/false synapse \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       git \
       build-essential \
       libffi-dev \
       python3-dev \
       python3-setuptools \
       python3-pip \
       sqlite3 \
       libssl-dev \
       python-virtualenv \
       libjpeg-dev \
       libxslt1-dev \
       gettext-base \
       libpq-dev \
    && python3 -m pip install --upgrade pip wheel \
    && pip install --upgrade psycopg2 jinja2 \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && git clone --branch "$SYNAPSE_TAG" --depth 1 https://github.com/matrix-org/synapse.git \
    && cd /synapse \
    && python3 -m pip install --upgrade .

RUN set -x \
    && mkdir -p /data /uploads /media_store /app-services \
    && python3 -m synapse.app.homeserver \
           --config-path /data/homeserver.yaml \
           --generate-config \
           -H "$SYNAPSE_HOST" \
           --report-stats=no \
    && chown -R synapse:synapse /data /uploads /media_store /app-services

ADD start.sh make_user.sh /

RUN set -x \
    && chmod +x /start.sh /make_user.sh

USER synapse

EXPOSE 8008

CMD ["/start.sh"]
