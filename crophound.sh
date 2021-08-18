#!/usr/bin/env bash
# https://github.com/maximuskowalski/trough/blob/master/crophound.sh
#
# A crop log sniffer
# https://github.com/l3uddz/crop
#
#__________________

# execute daily at "23:55"

set -Eeuo pipefail
IFS=$'\n\t'

#________ VARS

workpath="/home/$USER/trough"
logfile="/opt/crop/activity.log"

WEBHOOKID=ABC123
WEBHOOKTOKEN=i_a_bcdeFG123

ors1=": Transferred:"
ors2=
ors3=
ors4=
ors5="sync_movies"
ors6="sync_tv"


progress="${workpath}/progress.txt"
syncone="${workpath}/syncone.txt"
synctwo="${workpath}/synctwo.txt"
syncprog="${workpath}/syncprog.txt"

today=$(date '+%Y-%m-%d')

us1="0 / 0 Bytes, -, 0 Bytes/s, ETA -"
us2="dedupe"
us3="service"
us4="Running..."
us5="ETA 0s"
us6=".json"
us7="\-\-"



fld1="4-7"
del1=':'

delete1="00]  INFO rclone        :"
delete2="00] ERROR "
delete3=" : Error occurred while running syncer, skipping... error=failed and cannot proceed with exit code: 8"
delete4="00]  INFO "

TITLE="**Sync Progress**"
WOOK=discord://${WEBHOOKID}/${WEBHOOKTOKEN}

#________ FUNCTIONS

makelist() {
      grep "${today}" "${logfile}" | grep "${ors1}\|${ors5}\|${ors6}" | grep -v "${us1}\|${us2}\|${us3}\|${us4}\|${us5}\|${us6}" >"${progress}"
}

progtoday() {
      grep -B 2 -A 1 ERROR "${progress}" | cut -f "${fld1}" -d"${del1}" >"${syncone}"
}

deletions() {
      sed s/"${delete1}"//g "${syncone}" | sed s/"${delete2}"//g | sed s/"${delete3}"//g | sed s/"${delete4}"//g | grep -v "${us7}" >"${synctwo}"
}
format() {
      sed '/Syncing/i# ________' "${synctwo}" >"${syncprog}"
}

deliverance() {
      apprise -vv -t "${TITLE}" -b "${today}" -a "${syncprog}" "${WOOK}"
}

#________ SETLIST

makelist
progtoday
deletions
format
deliverance
