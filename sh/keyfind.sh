#!/bin/bash

root=`realpath $0`
root=`dirname $root`
root=`realpath $root/..`
echo "Working directory: $root"

if [ -z "$1" ]; then
	echo "$0 <token>"
	exit
fi

nohup $root/sh/torfind.sh $1 &
nohup $root/sh/i2pfind.sh $1 &

