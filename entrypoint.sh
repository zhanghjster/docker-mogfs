#!/usr/bin/bash

sleep 15

if [ ! -z $TRACKER  ]; then
    sh /home/mogile/mogilefs-db-init.sh
fi

rm -f /home/mogile/mogilefs-db-init.sh

exec $@
