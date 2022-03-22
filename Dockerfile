FROM debian:buster-slim

RUN apt update && apt install -y \
    apache2 \
    apache2-dev \
    build-essential \
    gettext \
    iproute2 \
    junit4 \
    liblz4-dev \
    libperl-dev \
    libserf-dev \
    libssl-dev \
    libutf8proc-dev \
    m4 \
    openjdk-11-jdk-headless \
    pax \
    python \
    python-dev \
    python-pip \
    python-yaml \
    py3c-dev \
    ruby \
    ruby-dev \
    swig \
    subversion \
    sudo \
    unzip \
    wget \
    zip \
    zlib1g-dev \
 && pip install ctypesgen && apt clean && chmod a+rw /opt

RUN useradd --create-home -s /bin/bash -u 501 svnrm \
        && echo svnrm:svnrm | chpasswd \
        && adduser svnrm sudo

USER svnrm
WORKDIR /home/svnrm