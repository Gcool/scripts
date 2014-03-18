#!/bin/bash
while true; do 
  echo -n "$(date "+%T") "                                                      
  sleep 1
  echo -ne "\x0d\E[2K"
done
