#!/bin/bash

from=$1
to=$2

if [ -z "$1" ]
  then   
    echo "$ move_cpuset.sh {from} {to}"
    exit
fi

if [ -z "$2" ]
  then   
    echo "$ move_cpuset.sh {from} {to}"
    exit
fi



for T in $(cat /sys/fs/cgroup/cpuset/${from}/tasks);
do
  ./add_task.sh $T ${to}    
done