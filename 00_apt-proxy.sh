#!/usr/bin/env bash

cd `dirname $0`

tee /etc/apt/apt.conf.d/10aptproxy << EOF
Acquire::http::Proxy "http://202.193.49.222:8080";
EOF
