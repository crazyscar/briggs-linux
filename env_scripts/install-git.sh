#!/bin/sh

#Build git from tarball on Centos

source ./common_func.sh

TargetDir=$HOME/opt/src
Ver=2.9.5
GitDir=git-${Ver}
GitTarF=${GitDir}.tar.xz

mkdir -p $TargetDir && cd $TargetDir

## install deps for build doc
sudo yum install -y asciidoc xmlto libcurl-devel perl-devel zlib-devel

function install_git {
    [ -e $GitTarF ] ||
        { echo "download ${GitTarF}...";
           wget https://www.kernel.org/pub/software/scm/git/${GitTarF}; 
        }
    [ -d $GitDir ] || tar xvf ${GitTarF}

    cd ${GitDir}
    NPROC=$(get_n_proc)
    ./configure && make -j${NPROC} all doc && sudo make install install-doc install-html 
}

install_git
