FROM nvidia/cuda:13.0.0-base-ubuntu24.04

ENV DB_USER='test' \
    DB_PASSWORD='test' \
    DB_HOST='localhost' \
    DB_DATABASE='test' \
    DB_PORT=3306 \
    DB_TYPE='mysql' \
    PLUGIN_KEYS='{}' \
    SSL_ENABLED='false' \
    SSL_COUNTRY='CA' \
    SSL_STATE='BC' \
    SSL_LOCATION='Vancouver' \
    SSL_ORGANIZATION='Shinobi Systems' \
    SSL_ORGANIZATION_UNIT='IT Department' \
    SSL_COMMON_NAME='nvr.ninja'

RUN mkdir -p /home/Shinobi /config && \
    apt update -y && \
    apt install -y software-properties-common \
        wget curl net-tools mysql-client \
        libfreetype6-dev \
        libgnutls28-dev \
        libmp3lame-dev \
        libass-dev \
        libogg-dev \
        libtheora-dev \
        libvorbis-dev \
        libvpx-dev \
        libwebp-dev \
        libssh2-1-dev \
        libopus-dev \
        librtmp-dev \
        libx264-dev \
        libx265-dev \
        yasm \
        build-essential \
        bzip2 \
        coreutils \
        procps \
        gnutls-bin \
        nasm \
        tar \
        x264 \
        ffmpeg \
        git \
        make \
        g++ \
        gcc \
        pkg-config \
        python3 \
        wget \
        tar \
        sudo \
        xz-utils && \
    apt update --fix-missing && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -  && \
    apt install -y nodejs && \
    apt clear && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* && \
    node -v && \
    npm -v && \
    git clone https://gitlab.com/Shinobi-Systems/Shinobi.git /home/Shinobi && \
    cd /home/Shinobi && \
    chmod -R 777 /home/Shinobi/plugins && \
    npm i npm@latest -g && \
    npm install --unsafe-perm && \
    npm install pm2 -g && \
    cp ./Docker/pm2.yml ./ 

COPY entrypoint.sh /home/Shinobi/entrypoint.sh

WORKDIR /home/Shinobi

EXPOSE 8080 443 21 25

VOLUME ["/home/Shinobi/videos", "/home/Shinobi/libs/customAutoLoad", "/config"]

ENTRYPOINT ["sh","/home/Shinobi/entrypoint.sh"]

CMD [ "pm2-docker", "/home/Shinobi/pm2.yml" ]

