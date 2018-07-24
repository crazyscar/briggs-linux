#!/bin/env sh

ROOT_DIR=$HOME/opt/src
VER=3.6.6
PYF="Python-${VER}"
TARBALL=${PYF}.tar.xz
URL="https://www.python.org/ftp/python/${VER}/Python-${VER}.tar.xz"

mkdir -p $ROOT_DIR

## install deps
sudo yum install -y libffi-devel zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel

## download src
cd $ROOT_DIR
if [ ! -f ${TARBALL} ];then
    wget $URL
fi
if [ ! -d ${PYF} ];then
    tar xvf ${TARBALL}
fi

cd ${PYF}
./configure && make -j 4 && sudo make altinstall
