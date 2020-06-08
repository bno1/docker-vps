FROM debian:buster-slim

RUN set -e \
    && apt update \
    && DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       htop \
       vim \
       neovim \
       iproute2 \
       iputils-ping \
       net-tools \
       curl \
       wget \
       git
