# Samsung_NANS
### Prerequisite
Whenever you turn on the board, follow steps below.
```
$ ./adb.sh
$ export XDG_RUNTIME_DIR=/run/user/root 
$ ./discovery-off.sh
$ systemctl stop discovery_rse2.service
```
### Performance Anomaly reproduce
To reproduce performance anomaly of experiment B + 5A and B + 5V, use `PA_reproduce/run.sh`.  

### Synthetic workload
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
