#!/usr/bin/env bash
set -euo pipefail
#set -xv
#
USER=max  # user name
GROUP=max # group name
SCRIPTPATH=/path/tothescript/snout.sh

sysdmaker() {
  sudo bash -c 'cat > /etc/systemd/system/snout.service' <<EOF
# /etc/systemd/system/snout.service
[Unit]
Description=snout
After=network-online.target

[Service]
User="${USER}"
Group="${GROUP}"
Type=simple
ExecStart="${SCRIPTPATH}"
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=snout

[Install]
WantedBy=default.target
EOF
}

enabler() {
  sudo systemctl daemon-reload
  sudo systemctl enable snout.service --now
}

sysdmaker
enabler
