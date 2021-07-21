#!/bin/bash

min=1024
def=65536
max=133813
file=/etc/sysctl.conf

sysctl -w net.ipv4.tcp_rmem="$min $def $max"

if grep -qF "net.ipv4.tcp_rmem" $file; then
	sed '/net.ipv4.tcp_rmem/c net.ipv4.tcp_rmem='"$min"' '"$def"' '"$max"'' "$file"
else
	sed '$a net.ipv4.tcp_rmem='"$min"' '"$def"' '"$max"'' "$file"
fi