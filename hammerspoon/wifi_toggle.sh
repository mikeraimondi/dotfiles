#!/bin/sh

DEVICE=$(networksetup -listallhardwareports | grep -A 2 -E "AirPort|Wi-Fi" | grep -m 1 -o -e en[0-9]);

if [ "$1" = on ]; then
  networksetup -setairportpower $DEVICE On
elif [ "$1" = off ]; then
  networksetup -setairportpower $DEVICE Off
fi
