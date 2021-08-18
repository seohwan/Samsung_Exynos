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
