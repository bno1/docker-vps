FROM debian:buster-slim

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
    && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       python3 \
       python3-setuptools \
       python3-pil \
       python3-psycopg2 \
       python3-pylibmc \
       python3-pip \
       python3-jinja2 \
       python3-sqlalchemy \
       libmemcached-dev \
       sqlite3 \
       wget \
       procps \
       ca-certificates \
       locales \
       patch \
    && pip3 --no-cache-dir install \
       django-pylibmc captcha django-simple-captcha \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN set -x \
    && mkdir /seafile \
    && cd /seafile \
    && wget https://download.seadrive.org/seafile-server_7.1.4_x86-64.tar.gz -O seafile-server-7.1.4.tar.gz \
    && tar xf seafile-server-7.1.4.tar.gz \
    && rm seafile-server-7.1.4.tar.gz \
    && chown -R seafile:seafile /seafile

ADD start.sh /seafile/start.sh
ADD setup.sh /seafile/setup.sh
ADD migrations.sh /seafile/migrations.sh
ADD setup.patch /seafile/setup.patch

RUN set -x \
    && chmod 755 /seafile/start.sh /seafile/setup.sh /seafile/migrations.sh

USER seafile
CMD ["bash", "-c", "/seafile/setup.sh seafile-server-7.1.4 && /seafile/start.sh"]
