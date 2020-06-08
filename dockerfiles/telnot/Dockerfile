FROM debian:buster-slim

RUN set -e \
    && groupadd -r telnot --gid=999 \
    && useradd -r -g telnot --uid=999 --shell=/bin/false telnot \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       git \
       python3 \
       python3-pip \
       python3-setuptools \
       python3-wheel \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && git clone https://github.com/fkolacek/TelNot.git /telnot \
    && pip3 install -r /telnot/requirements.txt

RUN set -x \
    && mkdir -p /telnot /telnot-data \
    && chown -R telnot:telnot /telnot /telnot-data \
    && ln -s /telnot-data/config.ini /telnot/config.ini

USER telnot
WORKDIR /telnot

EXPOSE 5000
CMD ["/telnot/app.py"]
