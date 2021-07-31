# OpenCL_workload

## Usage
### original version
```
$ mv mv1.mp4 /media/movies
$ export XDG_RUNTIME_DIR=/run/user/root 
$ chmod +x script.sh
$ ./script.sh
```  

### cpu isolation version
```
$ mv mp1.mp4 /media/movies
$ export XDG_RUNTIME_DIR=/run/user/root

# if you want to run abbreviated version of benchmark, 
# modify script_cpu_isolation.sh to run glmark2_small 
$ chmod +x benchmark_small.sh

$ chmod +x script_cpu_isolation.sh

# run gpu benchmark and gpu workload processes
./script_cpu_isolation.sh
```
