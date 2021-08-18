#!/usr/bin/env bash
# https://github.com/maximuskowalski/trough/blob/master/cropdog.sh
#
# A crop log sniffer
# https://github.com/l3uddz/crop
#
#__________________

# In systemd timer / cron set
# execute daily at 23:55 for a list of todays sunk files
# execute hourly for file notifications

set -Eeuo pipefail
IFS=$'\n\t'

#________ VARS

workpath="/home/$USER/trough/"
logfile="/opt/crop/activity.log"

WEBHOOKID=ABC123
WEBHOOKTOKEN=i_a_bcdeFG123

newfiles="${workpath}/newfiles.txt"
daylist="${workpath}/daylist.txt"
hlist="${workpath}/hourlist.txt"

NOW=$(date +"%m-%d %H:%M:%S")
thetime=$(date +%H:%M)
h1=$(date -d '1 hour ago' '+%Y-%m-%dT%H')
today=$(date '+%Y-%m-%d')

us1=".jpg"
s1=": Copied (server-side copy)"

del1='/'

TITLE="**New File ${NOW}**"
TITLE2="**${today}**"
WOOK=discord://${WEBHOOKID}/${WEBHOOKTOKEN}

#________ FUNCTIONS

makelist() {
      grep "${today}" "${logfile}" | grep -v "${us1}" | grep "${s1}" >"${newfiles}"
}

processor() {
      if [[ "${thetime}" > "23:50" && "${thetime}" < "23:59" ]]; then
            daylist
            processday
      else
            oneh
            processhour
      fi
}

daylist() {
      sed s/"${s1}"//g "${newfiles}" | rev | cut -d"${del1}" -f 1 | rev >"${daylist}"
}

oneh() {
      grep "${h1}" "${newfiles}" | sed s/"${s1}"//g | rev | cut -d"${del1}" -f 1 | rev >"${hlist}"
      body="${hlist}"
}

processhour() {
      while read f; do
            apprise -vv -t "${TITLE}" -b "$f" "${WOOK}"
            sleep 2
      done <${body}
}

processday() {
      apprise -vv -t "${TITLE2}" -b "todays files" -a "${daylist}" "${WOOK}"
}

#________ SETLIST

makelist
processor
