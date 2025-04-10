FROM php:8.2-apache

ENV READY=""
ENV PORT="28960"
ENV MODNAME=""
ENV MAP="+map_rotate"
ENV EXTRA=""
ENV SERVERTYPE=""
ENV EXECFILE="server.cfg"
ENV PUID="1000"
ENV PGID="100"
ENV GETGAMEFILES="0"

VOLUME ["/root/gamefiles/"]
EXPOSE 443 80

# Installer systempakker og PHP-udvidelser
RUN apt-get update && \
    apt-get install -y \
        gcc-multilib g++-multilib \
        unzip curl xz-utils nano \
        libpng-dev libjpeg-dev libfreetype6-dev \
        libzip-dev zlib1g-dev \
        libcurl4-openssl-dev \
        libonig-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install mysqli gd zip curl mbstring && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Kopiér script
COPY cod4/entrypoint.sh /root

RUN chmod -R 2777 /root && \
    chmod +x /root/entrypoint.sh

WORKDIR /root/gamefiles
ENTRYPOINT ["/root/entrypoint.sh"]
