#!/bin/env bash

VER=7.2.4
TAR_FZ=php-src-php-$VER
TARGET_DIR="$1"

echo "install deps..."
sudo yum install epel-release -y
sudo yum install autoconf libtool re2c bison libxml2-devel bzip2-devel libcurl-devel libpng-devel libicu-devel gcc-c++ libmcrypt-devel libwebp-devel libjpeg-devel openssl-devel -y

echo "download sources"
if [ -n $TARGET_DIR ];then
    curl -O -L https://github.com/php/php-src/archive/php-$VER.tar.gz
    tar -zxvf php-$VER.tar.gz
    cd php-src-php-$VER
fi

echo "building from source..."
./buildconf --force
./configure --prefix=/usr/local/php --enable-fpm --disable-short-tags --with-openssl --with-pcre-regex --with-pcre-jit --with-zlib --enable-bcmath --with-bz2 --enable-calendar --with-curl --enable-exif --with-gd --enable-intl --enable-mbstring --with-mysqli --enable-pcntl --with-pdo-mysql --enable-soap --enable-sockets --with-xmlrpc --enable-zip --with-webp-dir --with-jpeg-dir --with-png-dir

make clean
make
sudo make install
