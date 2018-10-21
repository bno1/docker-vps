FROM debian:stretch-slim

ENV SEAFILE_SERVER_NAME=seafile
ENV SEAFILE_DOMAIN=127.0.0.1
ENV SEAFILE_PORT=8082
ENV SEAFILE_POSTGRES_HOST=localhost
ENV SEAFILE_DB_PASSWORD=seafile
ENV SEAFILE_WEB_WORKERS=2
ENV SEAFILE_SU_EMAIL=admin@example.com
ENV SEAFILE_SU_PASSWORD=admin

RUN set -x \
    && groupadd -r seafile --gid=999 \
    && useradd -r -g seafile --uid=999 --shell=/bin/false seafile \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       python \
       python-setuptools \
       python-imaging \
       python-psycopg2 \
       python-pylibmc \
       python-pip \
       libmemcached-dev \
       sqlite3 \
       wget \
       procps \
       ca-certificates \
    && pip --no-cache-dir install \
       django-pylibmc \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && mkdir /seafile \
    && cd /seafile \
    && wget https://download.seadrive.org/seafile-server_6.3.4_x86-64.tar.gz -O seafile-server.tar.gz \
    && tar xf seafile-server.tar.gz \
    && rm seafile-server.tar.gz \
    && mv seafile-server-* seafile-server

ADD start.sh /seafile/start.sh

RUN set -x \
    && chown -R seafile:seafile /seafile \
    && chmod 755 /seafile/start.sh

USER seafile
CMD ["/seafile/start.sh"]
