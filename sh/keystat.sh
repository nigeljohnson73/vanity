#!/bin/bash

root=$(realpath $0)
root=$(dirname $root)
root=$(realpath $root/..)
echo "Working directory: $root"

hostname=$(hostname)
ipaddr=$(hostname -I | awk '{print $1;}')
i2prun=$(ps -ef | grep i2p_vanity | grep -v grep)
torrun=$(ps -ef | grep tor_vanity | grep -v grep)

if [ -z "$torrun" ]; then
	torrun="DN"
else
	torrun="UP"
fi
if [ -z "$i2prun" ]; then
	i2prun="DN"
else
	i2prun="UP"
fi

msg="$hostname($ipaddr): TOR-$torrun; I2P-$i2prun;"
echo $msg
$root/sh/phonehome "$msg"


