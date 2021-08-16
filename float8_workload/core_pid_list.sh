#!/bin/bash

TARGET_CPU=$1
if [ -z "$1" ]
  then   
    echo "$ core_pid_list.sh {Target CPU}"
    exit
fi

rm CPU_PIDs*

touch lastPIDs
touch CPU_PIDs

ps ax -o cpuid,pid | tail -n +2 | sort | xargs -n 2 | grep -E "^$TARGET_CPU" | awk '{print $2}' > lastPIDs
for i in {1..100}; do printf "#\n" >> lastPIDs; done
cp CPU_PIDs aux
paste lastPIDs aux > CPU_PIDs
column -t CPU_PIDs > CPU_PIDs.humanfriendly.tsv

cat CPU_PIDs | grep -v "#"