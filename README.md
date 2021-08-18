# Samsung_NANS
### Prerequisite
Whenever you turn on the board, follow steps below.
```
$ ./adb.sh
$ export XDG_RUNTIME_DIR=/run/user/root 
$ ./discovery-off.sh
$ systemctl stop discovery_rse2.service
```
### Performance Anomaly reproduce (B + [5A, 5V, 5S])
To reproduce performance anomaly of experiment with 5A, 5V, and 5S, use `PA_reproduce/run.sh`.  
CPU cores are not partitioned. 

### Synthetic workload (B + 5S)
To run synthetic workload (5S), use `float8_workload/`.  
#### CPU partitioning 
```
$ ./cpuset.sh
$ ./add_task.sh <terminal pid> <benchmark || workload>
```
#### Run synthetic workload
```
$ ./workload_script.sh
```
#### Run GPU benchmark
```
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
