#!/bin/bash

hostname=$(hostname)
ipaddr=$(hostname -I | awk '{print $1;}')

root=`realpath $0`
root=`dirname $root`
root=`realpath $root/..`
echo "Working directory: $root"

if [ -z "$1" ]; then
	echo "$0 <token>"
	exit
fi

run=`ps -ef | grep i2p_vanity | grep -v grep`

if [ ! -z "$run" ]; then
	echo "toolset already running"
else
	mkdir -p $root/keys_i2p
	cd $root/keys_i2p
	$root/sh/vanity_i2p $1 -t 2
	$root/sh/phonehome "$hostname($ipaddr): i2p vanity lookup completed for '$1'"
fi

