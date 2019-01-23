#!/bin/env bash

source ./common_func.sh

VER=7.2.4
PHP_FZ=php-src-php-$VER
PHP_TAR=php-$VER.tar.gz
NPROC=${get_n_proc}

echo "install deps..."
sudo yum install autoconf libtool re2c bison libxml2-devel bzip2-devel libcurl-devel libpng-devel libicu-devel gcc-c++ libmcrypt-devel libwebp-devel libjpeg-devel openssl-devel -y

if [ -n "$1" ];then
    TARGET_DIR="$1"
else
    TARGET_DIR=$HOME/opt/src
fi

mkdir -p $TARGET_DIR

cd $TARGET_DIR

[ -e $PHP_TAR ] ||
{ echo "downloading ${PHP_TAR}";
  curl -O -L https://github.com/php/php-src/archive/${PHP_TAR}
}


[ -d $PHP_FZ ] || tar -zxvf ${PHP_TAR}

cd $PHP_FZ

echo "building from source..."
./buildconf --force
./configure \
    --prefix=/opt/webserver/php7 --enable-fpm --disable-short-tags \
    --with-openssl --with-pcre-regex --with-pcre-jit --with-zlib \
    --enable-bcmath --with-bz2 --enable-calendar --with-curl --enable-exif \
    --with-gd --enable-intl --enable-mbstring --with-mysqli --enable-pcntl \
    --with-pdo-mysql --enable-soap --enable-sockets --with-xmlrpc --enable-zip \
    --with-webp-dir --with-jpeg-dir --with-png-dir

make clean
make -j${NPROC}
sudo make install
