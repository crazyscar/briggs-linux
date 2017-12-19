#!/bin/env zsh

FName=`readlink -e $0`
BaseDir=`dirname $FName`

sudo yum -y install zsh autojump-zsh

if [ ! -d $HOME/.oh-my-zsh ];then
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

cp -f $BaseDir/.zshrc ~/

CUSTOM_PATH=`cat $BaseDir/.zshrc | grep "ZSH_CUSTOM=" | grep -v "#" | awk -F '=' '{print $2}'`

if [ -z $CUSTOM_PATH ];then
    CUSTOM_PATH=$ZSH/custom
fi
cp -rf -R $BaseDir/custom/* $CUSTOM_PATH/

cd $HOME && source $HOME/.zshrc
