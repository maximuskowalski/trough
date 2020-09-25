#!/bin/sh
#
WATCHDIR=/mnt/unionfs/magazines
WATCHTXT="(?i)(Travel|photography|Consumer)"
WATCHFILE=/opt/scripts/trough/watch.txt
WEBHOOKID=123456    #discord webhook id
WEBHOOKTOKEN=ABC123 #discord webhook token

# DO NOT CHANGE
NOW=$(date +"%Y-%m-%d-%H-%M-%S")
WOOK=discord://${WEBHOOKID}/${WEBHOOKTOKEN}

inotifywait -qme create --format '%f' ${WATCHDIR} | while read line; do
  grep -P ${WATCHTXT} "$line" |
    apprise -vv -t "**Magazine Delivery**" -b "$f" "${WOOK}"
done

# inotifywait -qm --format '%f' -e create -e moved_to "${WATCHDIR}" | while read f; do
#     if grep -i 'travel\|consumer\|photgraphy' "$f"; then
#       echo "match $f"
#     else
#       echo "not match $f"
#     fi
#   done
