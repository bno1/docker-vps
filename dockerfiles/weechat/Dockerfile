FROM debian:stretch-slim

RUN set -e \
    && groupadd -r weechat --gid=999 \
    && useradd -r -g weechat --uid=999 --shell=/bin/false weechat \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       apt-transport-https \
       ca-certificates \
       gnupg2 \
       dirmngr \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 11E9DE8848F2B65222AA75B8D1820DB22A11534E \
    && echo 'deb https://weechat.org/debian stretch main' > /etc/apt/sources.list.d/weechat.list \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       weechat-headless \
       weechat-curses \
       weechat-plugins \
       weechat-python \
    && rm -rf /var/lib/apt/lists/*

RUN set -x \
    && mkdir -p /weechat-data \
    && chown -R weechat:weechat /weechat-data

USER weechat

EXPOSE 31416
EXPOSE 31417
CMD ["/usr/bin/weechat-headless", "-d", "/weechat-data"]
