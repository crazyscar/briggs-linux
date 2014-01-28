#!/usr/bin/env bash

EVENT_DIR="libevent-2.0.21-stable"
EVENT_TAR_GZ="libevent-2.0.21-stable.tar.gz"

TMUX_DIR="tmux-1.8"
TMUX_TAR_GZ="tmux-1.8.tar.gz"

PYTHON_URL="http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz"
PYTON_DIR="Python-2.7.6"

CONFIG_DIR="$HOME/briggs-linux"

VIM_URL="hg clone https://vim.googlecode.com/hg/"

VIM_RUNTIME_URL="https://github.com/crazyscar/vimrc.git"
VIM_RUNTIME="$HOME/.vim_runtime"


function check_tools
{
    tools=""
    git --version
    if (( $? !=0 )); then
        tools="$tools git"
    fi
    gcc --version 
    if (( $? !=0 )); then
        tools="$tools gcc"
    fi
    make --version 
    if (( $? !=0 )); then
        tools="$tools make"
    fi
    hg --version
    if (( $? !=0 )); then
        tools="$tools hg"
    fi
    if [[ $tools != ""  ]]; then
    	sudo yum install $tools -y
    fi
}

function install_tmux18
{
    ret=`tmux -V`
    if [[ $? != 0 || $ret != 'tmux 1.8' ]]; then
        echo "Compile libevent2.0+ "
        tar zxvf $CONFIG_DIR/$EVENT_TAR_GZ -C ~/
        cd ~/$EVENT_DIR
        ./configure && make && sudo make install
        sudo ln -s /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
        
        echo "yum install ncurses-devel"
        sudo yum install ncurses-devel -y

        tar zxvf $CONFIG_DIR/$TMUX_TAR_GZ -C ~/
        cd ~/$TMUX_DIR
        ./configure && make && sudo make install
    fi
}

function install_python27
{
    if [[ -e /opt/python2.7/bin/python2.7 ]];then
        echo "/opt/python2.7/bin/python2.7 exits"
        return
    fi
    cd ~/
    if [[ ! -e `basename $PYTHON_URL` ]]; then
    	wget $PYTHON_URL
    fi
    tar xvf `basename $PYTHON_URL`
    cd $PYTON_DIR
    ./configure --prefix=/opt/python2.7 && make && sudo make install 
}

function install_vim
{
    if [[ -e /opt/python2.7/bin/vim ]]; then
        echo "/opt/python2.7/bin/vim exists"
        return
    fi

    if [[ ! -d ~/vim ]]; then
        hg clone https://vim.googlecode.com/hg/ vim
    fi

    cd vim
    LD_LIBRARY_PATH=/opt/python2.7/lib PATH=/opt/python2.7/bin:$PATH ./configure --prefix=/opt/python2.7/ --with-features=huge --enable-pythoninterp=yes --with-python-config-dir=/opt/python2.7/lib/python2.7/config && make && sudo make install
}

# start

check_tools
install_tmux18
install_python27
install_vim

# basic config
grep WORKON_HOME ~/.bashrc
if (( $? !=0 )); then
    cat $CONFIG_DIR/bashsetting >> ~/.bashrc
fi

cp  -f $CONFIG_DIR/.tmux.conf ~/
sudo cp  -f $CONFIG_DIR/vim /usr/local/bin/

if [[ ! -d $VIM_RUNTIME ]]; then
    git clone $VIM_RUNTIME_URL $VIM_RUNTIME
fi
cd $VIM_RUNTIME
git submodule init
git submodule update
bash $VIM_RUNTIME/install_awesome_vimrc.sh

