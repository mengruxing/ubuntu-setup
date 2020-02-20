#!/usr/bin/env bash

cd "`dirname $0`/files" && rm -f MD5SUMS && md5sum * | tee MD5SUMS
