# TROUGH

a repository for little piggies

## SNOUT
##### SNOUT REQUIRES

sudo apt install inotify-tools

pip3 install apprise

##### SNOUT RUNNING OPTIONS

systemd - after +x & setting variables in snout.sh and installer.sh run installer.sh to install as systemd service.

in tmux

incron

nohup bash /opt/scripts/trough/snout.sh </dev/null >/dev/null 2>&1 &

With thanks to iXNyNe https://github.com/nemchik, check out https://github.com/GhostWriters/DockSTARTer

## CROPDOG And CROPHOUND

Crophound and Cropdog are both crop log sniffers.

See https://github.com/l3uddz/crop

Sample service files and timers are included in this repo - be sure to replace $USER with your user. Scripts will require a few variables to be set.

Set the location of this script as the working directory and the location of your crop log file. There is no accounting for log rotations in these scripts.

```
workpath="/home/$USER/trough/"
logfile="/opt/crop/activity.log"
```

You will also need to set your discord webhook token and ID. Other apprise notifications have not yet been added but might be soon.

```
WEBHOOKID=ABC123
WEBHOOKTOKEN=i_a_bcdeFG123
```
##### Crophound

Crophound will monitor and notify crop sync progress on a schedule via a text file attachment. It needs to be fed the names of your crop jobs.

```
ors5="sync_movies"
ors6="sync_tv"
```
Only two job names can be monitored in this version but if you use eg `mymovies` then this will also match jobs that contain the same string, like `mymovies_4k` or `mymovies_anime`.

##### Cropdog

Cropdog will monitor and notify crop sync files on a schedule.

Hourly runs will send a notification for every single file copied in the previous clock hour. Use is not recommended for mass transfers.

Running end of day at 23:55 will send a single notification with a text file attached containing a list of all files sunk that calendar day.
