#!/bin/sh
#
WATCHDIR="/mnt/unionfs/magazines"
WATCHTXT="(?i)(Travel|photography|Consumer)"
WATCHFILE=/opt/scripts/trough/watch.txt
WEBHOOKID=123456    #discord webhook id
WEBHOOKTOKEN=ABC123 #discord webhook token

# DO NOT CHANGE
NOW=$(date +"%Y-%m-%d-%H-%M-%S")
WOOK=discord://${WEBHOOKID}/${WEBHOOKTOKEN}

inotifywait -m --format '%f' -e create -e moved_to "${WATCHDIR}" | while read f; do
  if echo $f | grep -iP ${WATCHTXT}; then
    apprise -vv -t "**Magazine Delivery**" -b "$f" "${WOOK}"
  fi
done
