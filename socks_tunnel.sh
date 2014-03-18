#!/bin/bash

# Variables:
PORT=8080
SSH_USER='username'
SSH_HOST='your.hostname.com'

# Default Process ID file
#PID_FILE="/tmp/tunnel-${SSH_USER}.pid"

# User specified:
if [ -n "$1" ]
    then
    SSH_USER=$1
fi

PID=$(pgrep -f "${SSH_USER}@${SSH_HOST}")

if [[ -n $PID ]]; then
    stat_busy "Killing the tunnel"
    kill $PID && stat_done || stat_fail
else
    stat_busy "Setting up the tunnel"
    ssh -qfND ${PORT} ${SSH_USER}@${SSH_HOST} && stat_done || stat_fail
fi
