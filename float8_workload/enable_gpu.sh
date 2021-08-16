#!/bin/sh

gpu=$1

if [ -z "$1" ]
  then   
    echo "$ disable_gpu.sh {target}"
    exit
fi

if [ $gpu == mp12 ]; then
    echo 1 > /sys/devices/platform/19700000.G3D1/util_enable    
elif [ $gpu == mp3_00 ]; then
    echo 1 > /sys/devices/platform/19300000.G3D00/util_enable
elif [ $gpu == mp3_01 ]; then
    echo 1 > /sys/devices/platform/19500000.G3D01/util_enable
else
    echo "Invalid target gpu"
fi

echo "========= GPU SETATUS ========="
echo "[mp12]"
cat /sys/devices/platform/19700000.G3D1/util_enable
echo "[mp3_00]"
cat /sys/devices/platform/19300000.G3D00/util_enable
echo "[mp3_01]"
cat /sys/devices/platform/19500000.G3D01/util_enable
echo "==============================="