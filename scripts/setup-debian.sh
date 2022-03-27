sudo apt update
sudo apt upgrade

sudo apt install -y \
    apache2 \
    apache2-dev \
    build-essential \
    gettext \
    git \
    gnupg \
    iproute2 \
    junit4 \
    liblz4-dev \
    libperl-dev \
    libserf-dev \
    libssl-dev \
    libutf8proc-dev \
    m4 \
    pax \
    python \
    python-dev \
    python-pip \
    python-yaml \
    py3c-dev \
    ruby \
    ruby-dev \
    software-properties-common \
    subversion \
    sudo \
    swig \
    unzip \
    wget \
    zip \
    zlib1g-dev

#
# Install Java 8
#
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt update && sudo apt install adoptopenjdk-8-hotspot

git clone https://github.com/markphip/svnrm.git