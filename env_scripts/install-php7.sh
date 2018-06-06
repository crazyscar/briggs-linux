#!/bin/env bash

VER=7.2.4
PHP_FZ=php-src-php-$VER
PHP_TAR=php-$VER.tar.gz

echo "install deps..."
sudo yum install autoconf libtool re2c bison libxml2-devel bzip2-devel libcurl-devel libpng-devel libicu-devel gcc-c++ libmcrypt-devel libwebp-devel libjpeg-devel openssl-devel -y

if [ -n "$1" ];then
    TARGET_DIR="$1"
else
    TARGET_DIR=`pwd`
fi

cd $TARGET_DIR

if [ -f $PHP_TAR ];then
    echo "file $PHP_TAR exists, skip download"
else
    echo "download $PHP_TAR"
    curl -O -L https://github.com/php/php-src/archive/php-$VER.tar.gz
fi

if [ -d $PHP_FZ ];then
    echo "already extract, skip tar extract"
else
    tar -zxvf php-$VER.tar.gz
fi

cd $PHP_FZ

echo "building from source..."
./buildconf --force
./configure --prefix=/opt/webserver/php7 --enable-fpm --disable-short-tags --with-openssl --with-pcre-regex --with-pcre-jit --with-zlib --enable-bcmath --with-bz2 --enable-calendar --with-curl --enable-exif --with-gd --enable-intl --enable-mbstring --with-mysqli --enable-pcntl --with-pdo-mysql --enable-soap --enable-sockets --with-xmlrpc --enable-zip --with-webp-dir --with-jpeg-dir --with-png-dir

make clean
make -j4
sudo make install
