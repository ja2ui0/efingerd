#!/bin/sh

service openbsd-inetd start
tail -f /var/log/efingerd.log
