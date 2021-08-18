# Samsung_NANS
### Prerequisite
Whenever you turn on the board, follow steps below.
```
$ ./adb.sh
$ export XDG_RUNTIME_DIR=/run/user/root 
$ ./discovery-off.sh
$ systemctl stop discovery_rse2.service
```
---
### 1. Performance Anomaly reproduce (B + [5A, 5V, 5S])
To reproduce performance anomaly of experiment with 5A, 5V, and 5S, use `PA_reproduce/run.sh`.  
In this experiment, CPU cores are not partitioned.  
**GPU separation** : change `benchmark_instance` and `workload_instance` in `run.sh`

### 2. Synthetic workload experiment (B + 5S)
To run synthetic workload (5S), use `float8_workload/`.  
**GPU separation** : change `benchmark_instance` in `benchmark_script.sh` and `workload_instance` in `workload_script.sh`

#### CPU partitioning 
By default, `benchmark` cpuset's cpu is 4 and `workload` cpuset's cpu is 1.  
```
$ cd float8_workload
$ ./cpuset.sh
$ ./add_task.sh $$ benchmark

# Single CPU
$ ./add_task.sh <adb shell's pid> benchmark
# CPU partitioning
$ ./add_task.sh <adb shell's pid> workload
```
#### Run synthetic workload
```
# adb shell
$ cd float8_workload
$ ./workload_script.sh
```
#### Run GPU benchmark
```
# putty (serial port connection)
$ ./benchmark_script.sh
```
### 3. 5V exp + CPU partitioning
```
$ cd float8_workload
$ ./add_task.sh $$ benchmark
$ ./enable_gpu.sh <workload_gpu> && ./disable_gpu.sh <benchmark_gpu> 
$ ./5V_script.sh # and play videos
$ ./enable_gpu.sh <benchmark_gpu>
$ ./move_cpuset.sh benchmark workload
$ cat /sys/fs/cgroup/cpuset/benchmark/tasks # check if empty
$ cat /sys/fs/cgroup/cpuset/workload/tasks # check if rse-compositor tasks are there
$ ./add_task.sh $$ benchmark
$ ./benchmark_script.sh
```
---
If you are using freshly flashed board, create input file by
```
$ cp mv1.mp4 /media/movies/
```
To monitor GPU utilization, 
```
$ ./float8_workload/enable_gpu.sh <gpu>
$ ./float8_workload/cat_util.sh
```
