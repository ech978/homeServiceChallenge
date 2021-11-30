#!/bin/bash

acmFile=$(cd /dev && find -name ttyACM0)

# if file not found
if [ -z $acmFile ]; then
    echo "ttyACM0 was not found"
    echo "Install CDCACM.sh"
    . ~/Downloads/installACMModule-master/installCDCACM.sh
    echo "Install Success"
fi

while true; do
    acmFile=$(cd /dev && find -name ttyACM0)
    if [ -z $acmFile ]; then
        echo "Please reconnect usb cable"
    else
        echo "Reconnect Success"
        break
    fi
    sleep 1
done
