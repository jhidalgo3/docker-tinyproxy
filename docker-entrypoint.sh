#!/bin/sh

touch /var/log/tinyproxy/tinyproxy.log
chmod 777 /var/log/tinyproxy/tinyproxy.log

CONFIG='/etc/tinyproxy/tinyproxy.conf';

([ -z "$UPSTREAM" ] || sed -i "s|^#upstream testproxy|$UPSTREAM|" "$CONFIG");

([ -z "$LOG_LEVEL" ] || sed -i "s|^LogLevel Info|LogLevel $LOG_LEVEL|" "$CONFIG");


exec "$@" &
tail -f /var/log/tinyproxy/tinyproxy.log
