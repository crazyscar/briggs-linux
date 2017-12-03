#!/bin/bash

socat STDIO PROXY:proxyurl:$1:$2,proxyport=8088
