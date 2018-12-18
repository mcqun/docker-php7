FROM php:7.3.0-fpm-alpine3.8

LABEL maintainer="Mcqun <mchqun@126.com>" version="1.0"

ARG timezone
# prod pre test dev
ARG app_env=prod
ARG add_user=www-data

RUN set -ex \
  # change apk source repo
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/' /etc/apk/repositories \
  && apk update \
  && apk add --no-cache \
  libzip-dev \
  libressl \
  libmcrypt-dev \
  libpng-dev \
  icu-dev \
  libxslt-dev \
  libffi-dev \
  freetype-dev \
  libjpeg-turbo-dev \
  && docker-php-ext-configure gd \
  --with-gd \
  --with-freetype-dir=/usr/include/ \
  --with-png-dir=/usr/include/ \
  --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  # - install php extension
  && docker-php-ext-install zip pdo_mysql opcache mysqli sockets mbstring exif \
  # - create user dir
  && mkdir -p /www \
  && chown -R ${add_user}:${add_user} /www \
  && echo -e "\033[42;37m Build Completed :).\033[0m\n"

ENV APP_ENV=${app_env:-"prod"} \
  TIMEZONE=${timezone:-"Asia/Shanghai"}

# - config timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
  && echo "${TIMEZONE}" > /etc/timezone 

VOLUME  /www
WORKDIR /www