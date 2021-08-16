#!/bin/bash

# TODO : automation

temp='/sys/class/thermal/thermal_zone*/temp'
mp3_00='/sys/devices/platform/19300000.G3D00'
mp3_01='/sys/devices/platform/19500000.G3D01'
mp12='/sys/devices/platform/19700000.G3D1'

#echo 1 > ${mp12}/util_enable
echo 1 > ${mp3_00}/util_enable
echo 1 > ${mp3_01}/util_enable

watch -n 0.5 'echo ==================================== ; \
cat /sys/class/thermal/thermal_zone*/temp; \
echo ====================================; \
cat /sys/devices/platform/19300000.G3D00/utilization; \
cat /sys/devices/platform/19500000.G3D01/utilization \
'