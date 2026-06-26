#!/bin/bash

root=`realpath $0`
root=`dirname $root`
root=`realpath $root/..`
echo "Working directory: $root"

if [ -z "$1" ]; then
	echo "$0 <token>"
	exit
fi

run=`ps -ef | grep tor_vanity | grep -v grep`

if [ ! -z "$run" ]; then
	echo "toolset already running"
else
	mkdir -p $root/tor_keys
	cd $root/tor_keys
	$root/sh/tor_vanity $1 -v -n 1 -d . -t 2 -s
	$root/sh/phonehome.sh "tor vanity lookup completed for '$1'"
fi

