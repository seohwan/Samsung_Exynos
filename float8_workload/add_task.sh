if [ -z "$1" ]
  then   
    echo "$ add_task.sh {Target PID} {cpuset name}"
    exit
fi

if [ -z "$2" ]
  then   
    echo "$ add_task.sh {Target PID} {cpuset name}"
    exit
fi

/bin/echo $1 > /sys/fs/cgroup/cpuset/$2/tasks
