#!/bin/env sh

if [ -n "$1" ];then
    TARGET_DIR="$1"
else
    TARGET_DIR=`pwd`
fi

VER="1.14.0"
NGINX="nginx-$VER"
NGINX_TAR="$NGINX.tar.gz"

cd $TARGET_DIR
if [ -f $NGINX_TAR ];then
    echo "file $NGINX_TAR exists, skip downloading"
else
    wget https://nginx.org/download/$NGINX_TAR
fi

tar xvf $NGINX_TAR

sudo groupadd -r nginx
sudo useradd -s /sbin/nologin -g nginx -r nginx

sudo yum install -y pcre-devel zlib-devel openssl-devel

cd $NGINX && ./configure --prefix=/opt/webserver/nginx --with-http_ssl_module --with-stream --with-stream_ssl_module --user=nginx --group=nginx && make -j4 && sudo make install

echo "nginx is under /opt/webserver/nginx"
