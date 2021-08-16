#!/bin/bash

let benchmark_core_num=4
let workload_core_num=2

if [[ $(id -u) -ne 0 ]]; then 
	echo "Please run as root"
  exit
fi

if [ ! -d /sys/fs/cgroup/cpuset/benchmark ]; then
    echo "/sys/fs/cgroup/cpuset/benchmark does not exist"
    mkdir /sys/fs/cgroup/cpuset/benchmark
fi

if [ ! -d /sys/fs/cgroup/cpuset/workload ]; then
    echo "/sys/fs/cgroup/cpuset/workload does not exist"
    mkdir /sys/fs/cgroup/cpuset/workload
fi

sudo echo -1 > /proc/sys/kernel/sched_rt_runtime_us # sched rt check off

/bin/echo 0 > /sys/fs/cgroup/cpuset/cpuset.sched_load_balance

/bin/echo 0 > /sys/fs/cgroup/cpuset/benchmark/cpuset.mems
/bin/echo $benchmark_core_num > /sys/fs/cgroup/cpuset/benchmark/cpuset.cpus
/bin/echo 1 > /sys/fs/cgroup/cpuset/benchmark/cpuset.sched_load_balance
/bin/echo 1 > /sys/fs/cgroup/cpuset/benchmark/cpuset.cpu_exclusive
/bin/echo 0 > /sys/fs/cgroup/cpuset/benchmark/cpuset.mem_exclusive
/bin/echo 1 > /sys/fs/cgroup/cpuset/benchmark/cpuset.memory_migrate

/bin/echo 0 > /sys/fs/cgroup/cpuset/workload/cpuset.mems
/bin/echo $workload_core_num > /sys/fs/cgroup/cpuset/workload/cpuset.cpus
/bin/echo 1 > /sys/fs/cgroup/cpuset/workload/cpuset.sched_load_balance
/bin/echo 1 > /sys/fs/cgroup/cpuset/workload/cpuset.cpu_exclusive
/bin/echo 0 > /sys/fs/cgroup/cpuset/workload/cpuset.mem_exclusive
/bin/echo 1 > /sys/fs/cgroup/cpuset/workload/cpuset.memory_migrate


printf "=========== CPUSET STATUS ===========\n"
printf "[benchmark] cpuset.mems: "
cat /sys/fs/cgroup/cpuset/benchmark/cpuset.mems
printf "[benchmark] cpuset.cpus: "
cat /sys/fs/cgroup/cpuset/benchmark/cpuset.cpus
printf "[benchmark] cpuset.cpu_exclusive: "
cat /sys/fs/cgroup/cpuset/benchmark/cpuset.cpu_exclusive
printf "[benchmark] cpuset.mem_exclusive: "
cat /sys/fs/cgroup/cpuset/benchmark/cpuset.mem_exclusive
printf "[benchmark] cpuset.memory_migrate: "
cat /sys/fs/cgroup/cpuset/benchmark/cpuset.memory_migrate

printf "\n"

printf "[workload] cpuset.mems: "
cat /sys/fs/cgroup/cpuset/workload/cpuset.mems
printf "[workload] cpuset.cpus: "
cat /sys/fs/cgroup/cpuset/workload/cpuset.cpus
printf "[workload] cpuset.cpu_exclusive: "
cat /sys/fs/cgroup/cpuset/workload/cpuset.cpu_exclusive
printf "[workload] cpuset.mem_exclusive: "
cat /sys/fs/cgroup/cpuset/workload/cpuset.mem_exclusive
printf "[workload] cpuset.memory_migrate: "
cat /sys/fs/cgroup/cpuset/workload/cpuset.memory_migrate
printf "=====================================\n"

