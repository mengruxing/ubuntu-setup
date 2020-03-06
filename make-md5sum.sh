#!/usr/bin/env bash

cd "`dirname $0`/local" && rm -f MD5SUMS && md5sum * | grep -v 'config.sh' | tee MD5SUMS
