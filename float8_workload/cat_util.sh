#!/bin/sh

mp12='/sys/devices/platform/19700000.G3D1'
mp3_00='/sys/devices/platform/19300000.G3D00'
mp3_01='/sys/devices/platform/19500000.G3D01'

if [ -d $mp12 ] && [ -d $mp3_00 ]; then
    watch -n 1 'echo top: mp12 / bottom: mp3_00; cat /sys/devices/platform/19700000.G3D1/utilization; cat /sys/devices/platform/19300000.G3D00/utilization'

elif [ -d $mp12 ] && [ -d $mp3_01 ]; then
    watch -n 1 'echo top: mp12 / bottom: mp3_01; cat /sys/devices/platform/19700000.G3D1/utilization; cat /sys/devices/platform/19500000.G3D01/utilization'

elif [ -d $mp3_00 ] && [ -d $mp3_01 ]; then
    watch -n 1 'echo top: mp3_00 / bottom: mp3_01; cat /sys/devices/platform/19300000.G3D00/utilization; cat /sys/devices/platform/19500000.G3D01/utilization'

fi

