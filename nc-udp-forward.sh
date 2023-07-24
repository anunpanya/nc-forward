#!/usr/bin/env bash

set -e

if [ $# != 3 ]; then

        echo 'Usage: nc-udp-forward.sh $FRONTPORT $BACKHOST $BACKPORT' >&2
        exit 1
fi

FRONTPORT=$1
BACKHOST=$2
BACKPORT=$3

FIFO=/tmp/backpipe

trap 'echo "trapped."; pkill nc; rm -f $FIFO; exit 1' 1 2 3 15

mkfifo $FIFO
while true; do
        nc -l -u $FRONTPORT <$FIFO | nc -u $BACKHOST $BACKPORT >$FIFO
done
rm -f $FIFO
