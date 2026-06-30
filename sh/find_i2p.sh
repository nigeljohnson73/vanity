#!/bin/bash

hostname=$(hostname)
ipaddr=$(hostname -I | awk '{print $1;}')
keyset="i2p"

root=`realpath $0`
root=`dirname $root`
root=`realpath $root/..`
echo "Working directory: $root"

run=`ps -ef | grep "vanity_$keyset" | grep -v grep`

if [ ! -z "$run" ]; then
	echo "toolset already running"
else
	mkdir -p $root/keys_$keyset
	while [ 1 ]; do
		threads=$($root/sh/vanityctl thget $keyset)
		key=$($root/sh/vanityctl current $keyset)
		if [ -z "$key" ]; then
			echo "$keyset search complete"
			exit
		else
			cd $root/keys_$keyset
			if [ "$keyset" = "i2p" ]; then
				echo "$root/sh/vanity_i2p -r \"$key\" -t $threads"
				$root/sh/vanity_i2p -r "$key" -t $threads
			fi
			if [ "$keyset" = "tor" ]; then
				echo "$root/sh/vanity_tor $key -v -n 1 -d . -t $threads -s"
				$root/sh/vanity_tor $key -v -n 1 -d . -t $threads -s
			fi
			echo "$hostname($ipaddr): $keyset vanity lookup completed for '$key'"
			nice -n 5 $root/sh/phonehome "$hostname($ipaddr): $keyset vanity lookup completed for '$key'"
			$root/sh/vanityctl remove $keyset $key
		fi
	done
fi

