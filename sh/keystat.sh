#!/bin/bash

root=$(realpath $0)
root=$(dirname $root)
root=$(realpath $root/..)
echo "Working directory: $root"

hostname=$(hostname)
ipaddr=$(hostname -I | awk '{print $1;}')
i2prun=$(ps -ef | grep vanity_i2p | grep -v grep)
torrun=$(ps -ef | grep vanity_tor | grep -v grep)
temp=$(vcgencmd measure_temp)
throttled=$(vcgencmd get_throttled)

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

msg="$hostname($ipaddr): TOR=$torrun; I2P=$i2prun; $temp; $throttled"
echo $msg
$root/sh/phonehome "$msg"


