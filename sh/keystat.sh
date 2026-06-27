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
	torrun="DOWN"
else
	torrun="UP"
	torrun=$($root/sh/vanityctl current tor)
fi
if [ -z "$i2prun" ]; then
	i2prun="DOWN"
else
	i2prun="UP"
	i2prun=$($root/sh/vanityctl current i2p)
fi

msg="$hostname: tor=$torrun; i2p=$i2prun; $temp; $throttled; ip=$ipaddr"
echo $msg
$root/sh/phonehome "$msg"

