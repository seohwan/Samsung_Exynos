cpus_sys=0
cpus_benchmark=4
cpus_workload=1

mkdir /cpuset
mount -t cpuset none /cpuset/
cd /cpuset

mkdir sys 
echo $cpus_sys > sys/cpuset.cpus

echo 1 > sys/cpuset.cpu_exclusive
echo 0 > sys/cpuset.mems

mkdir benchmark
echo $cpus_benchmark > benchmark/cpuset.cpus

echo 1 > benchmark/cpuset.cpu_exclusive
echo 0 > benchmark/cpuset.mems
echo 1 > benchmark/cpuset.mem_hardwall

mkdir workload
echo $cpus_workload > workload/cpuset.cpus

echo 1 > workload/cpuset.cpu_exclusive
echo 0 > workload/cpuset.mems
echo 1 > workload/cpuset.mem_hardwall

# move all processes from the default cpuset to the sys-cpuset
for T in $(cat tasks); do echo "Moving " $T; echo $T > sys/tasks; done

# when starting benchmark or workload processes,
# echo $PID > /cpuset/benchmark(workload)/tasks
