#!/bin/sh

DEVICE=$(networksetup -listallhardwareports | grep -A 2 -E "AirPort|Wi-Fi" | grep -m 1 -o -e en[0-9]);
networksetup -setairportpower $DEVICE On
