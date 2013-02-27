#!/bin/bash

socat STDIO PROXY:web-proxy.cup.hp.com:$1:$2,proxyport=8088
