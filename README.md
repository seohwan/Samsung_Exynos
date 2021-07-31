# OpenCL_workload

## Usage
### Prerequisite
```
$ mv mv1.mp4 /media/movies
$ export XDG_RUNTIME_DIR=/run/user/root 
$ chmod +x *.sh
```

### Original version
```
$ ./script.sh
```  

### CPU isolation version
```
# if you want to run abbreviated version of benchmark, 
# modify script_cpu_isolation.sh to run glmark2_small 

# run gpu benchmark and gpu workload processes
./script_cpu_isolation.sh
```

### Run glmark2 only
```
$ ./b1.sh
```
