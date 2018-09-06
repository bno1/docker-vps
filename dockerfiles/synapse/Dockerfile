FROM debian:stretch-slim

ARG SYNAPSE_TAG=master
ARG SYNAPSE_HOST=example.org

RUN set -x \
    && groupadd -r synapse --gid=999 \
    && useradd -r -g synapse --uid=999 --shell=/bin/false synapse \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       file \
       gcc \
       git \
       libevent-dev \
       libffi-dev \
       libgnutls28-dev \
       libjpeg62-turbo-dev \
       libldap2-dev \
       libsasl2-dev \
       libsqlite3-dev \
       libssl-dev \
       libtool \
       libxml2-dev \
       libxslt1-dev \
       linux-headers-amd64 \
       make \
       python-dev \
       python-setuptools \
       zlib1g-dev \
       libevent-2.0-5 \
       libffi6 \
       libjpeg62-turbo \
       libldap-2.4-2 \
       libssl1.1 \
       libtool \
       libxml2 \
       libxslt1.1 \
       pwgen \
       python \
       python-pip \
       python-psycopg2 \
       python-virtualenv \
       python-jinja2 \
       sqlite \
       zlib1g \
       gettext-base \
    && python -m pip install --upgrade pip wheel \
    && python -m pip install --upgrade python-ldap lxml supervisor \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && git clone --branch "$SYNAPSE_TAG" --depth 1 https://github.com/matrix-org/synapse.git \
    && cd /synapse \
    && python -m pip install --upgrade --process-dependency-links .

RUN set -x \
    && mkdir -p /data /uploads /media_store /app-services \
    && python -m synapse.app.homeserver \
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
