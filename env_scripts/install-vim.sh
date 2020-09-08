#!/bin/bash

## build vim from source

TargetDir=$HOME/opt/src
VimVer=8.2.1000
VimTar=vim-${VimVer}.tar.bz
VimDir=vim-${VimVer}

mkdir -p ${TargetDir}

function get_vim {
    cd ${TargetDir}
    [ -d ${VimDir} ] ||
    {
    	wget https://github.com/vim/vim/archive/v${VimVer}.tar.gz -O ${VimTar}
        tar xvf ${VimTar}
    }
}

function install_vim_deps {
    sudo yum install -y  ruby ruby-devel lua lua-devel luajit \
    	luajit-devel ctags python python-devel gettext \
    	python3 python3-devel tcl-devel \
    	perl perl-devel perl-ExtUtils-ParseXS \
    	perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
    	perl-ExtUtils-Embed 
}

function install_vim {
    cd ${TargetDir}/${VimDir}

    ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --prefix=/usr/local
    make && sudo make install

    sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
    sudo update-alternatives --set editor /usr/local/bin/vim
    sudo update-alternatives --set vi /usr/local/bin/vim
}

get_vim
install_vim_deps
install_vim
