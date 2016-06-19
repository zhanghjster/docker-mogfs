#!/usr/bin/bash

if [ ! -z $TRACKER  ]; then
    until nmap -p 3306 mysqlhost -oG -| grep open; do
        sleep 1;
    done

    sh /home/mogile/mogilefs-db-init.sh

fi

rm -f /home/mogile/mogilefs-db-init.sh

exec $@
