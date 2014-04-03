#!/bin/sh

vim74_with_python27="/opt/python2.7/bin/vim"
vim74="/opt/bin/vim"

python -V 2>&1 | grep '2.7' 1>/dev/null

if [ $? = 0 ]; then
    vim=${vim74_with_python27}
elif [ -x $vim74 ]; then
    vim=${vim74}
else
    vim="/usr/bin/vim"
fi

exec $vim "$@"
