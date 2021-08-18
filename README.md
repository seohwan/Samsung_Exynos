# Samsung_NANS

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
To monitor GPU utilization, 
```
$ ./float8_workload/enable_gpu.sh <gpu>
$ ./float8_workload/cat_util.sh
```
