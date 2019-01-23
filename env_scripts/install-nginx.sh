#!/bin/env sh

#build nginx from tarball

source ./common_func.sh

if [ -n "$1" ];then
    TARGET_DIR="$1"
else
    TARGET_DIR=$HOME/opt/src
fi

mkdir -p $TARGET_DIR

VER="1.14.0"
NGINX="nginx-$VER"
NGINX_TAR="$NGINX.tar.gz"

cd $TARGET_DIR

[ -e $NGINX_TAR ] ||
{ echo "downloading ${NGINX_TAR}";
  wget https://nginx.org/download/$NGINX_TAR
}

tar xvf $NGINX_TAR

sudo groupadd -r nginx
sudo useradd -s /sbin/nologin -g nginx -r nginx

sudo yum install -y pcre-devel zlib-devel openssl-devel

NPROC=$(get_n_proc)

cd $NGINX && ./configure \
    --prefix=/opt/webserver/nginx --with-http_ssl_module \
    --with-stream --with-stream_ssl_module --user=nginx --group=nginx \
    && make -j${NPROC} && sudo make install

echo "nginx is under /opt/webserver/nginx"
