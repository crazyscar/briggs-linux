#!/bin/sh

TARGET_DIR=$HOME/opt/src/

if [ -n "$1" ];then
    TARGET_DIR=$1
fi

mkdir -p $TARGET_DIR

cd $TARGET_DIR

LIB_EVENT_TGZ=libevent-2.0.21-stable.tar.gz
TMUX_TGZ=tmux-2.6.tar.gz

# install deps
sudo yum install gcc kernel-devel make ncurses-devel -y

function install_libevent_2_x {
    # DOWNLOAD SOURCES FOR LIBEVENT AND MAKE AND INSTALL
    [ -e $LIB_EVENT_TGZ ] || wget https://github.com/downloads/libevent/libevent/${LIB_EVENT_TGZ}
    tar -xvzf libevent-2.0.21-stable.tar.gz
    cd libevent-2.0.21-stable
    ./configure --prefix=/usr/local && \\
    m_make && \\
    sudo make install
}

function install_tmux_2_6 {
    # DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
    [ -e $TMUX_TGZ ] || wget https://github.com/tmux/tmux/releases/download/2.6/${TMUX_TGZ}
    tar -xvzf tmux-2.6.tar.gz
    cd tmux-2.6
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
    m_make && \\
    sudo make install
}

function install_tmux_tpm {
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 
}

install_libevent_2_x 
install_tmux_2_6
install_tmux_tpm
