#!/bin/sh

instance=$1
version=$2
step=$3
read=$4
write=$5
sleep=$6

MALI_INSTANCE=$instance ./test $version $step $read $write $sleep &
MALI_INSTANCE=$instance ./test $version $step $read $write $sleep &
MALI_INSTANCE=$instance ./test $version $step $read $write $sleep &
MALI_INSTANCE=$instance ./test $version $step $read $write $sleep &
MALI_INSTANCE=$instance ./test $version $step $read $write $sleep 
