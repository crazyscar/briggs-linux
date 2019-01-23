#!/bin/env sh

source ./common_func.sh

TargetDir=$HOME/opt/src
VER=3.6.6
PYF="Python-${VER}"
TARBALL=${PYF}.tar.xz
URL="https://www.python.org/ftp/python/${VER}/Python-${VER}.tar.xz"
NPROC=$(get_n_proc)

mkdir -p $TargetDir

## install deps
sudo yum install -y libffi-devel zlib-devel bzip2-devel openssl-devel \
    ncurses-devel sqlite-devel readline-devel tk-devel

## download src
cd $TargetDir
[ -e ${TARBALL} ] ||
    { echo "downloading ${TARBALL}";
      wget $URL
    }
[ -d ${PYF}] || tar xvf ${TARBALL}

cd ${PYF}
./configure && make -j${NPROC} && sudo make altinstall
