FROM debian:9-slim

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       wget \
       gnupg \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://prosody.im/files/prosody-debian-packages.key -O- | apt-key add -

RUN echo deb http://packages.prosody.im/debian stretch main >> /etc/apt/sources.list

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       lsb-base \
       adduser \
       libidn11 \
       libssl1.1 \
       lua-bitop \
       lua-dbi-mysql \
       lua-dbi-postgresql \
       lua-dbi-sqlite3 \
       lua-event \
       lua-expat \
       lua-filesystem \
       lua-sec \
       lua-socket \
       lua-zlib \
       lua5.1 \
       openssl \
       ssl-cert \
       prosody \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443 5222 5269 5347 5280 5281
USER prosody
ENV __FLUSH_LOG yes
CMD ["prosody"]
