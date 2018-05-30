#!/bin/sh

#Build git from tarball on Centos

TargetDir=~/opt/src
Ver=2.9.5
GitDir=git-${Ver}
GitTarF=${GitDir}.tar.xz

mkdir -p $TargetDir && cd $TargetDir

## install deps for build doc
sudo yum install -y asciidoc xmlto libcurl-devel perl-devel zlib-devel

function install_git {
    if [ ! -e $GitTarF ];then
        wget https://www.kernel.org/pub/software/scm/git/${GitTarF}
    fi
    if [ ! -d $GitDir ];then
	tar xvf ${GitTarF}
    fi
    cd ${GitDir}
    ./configure && make all doc && sudo make install install-doc install-html 
}

install_git
