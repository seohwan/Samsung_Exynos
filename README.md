# OpenCL_workload

## Usage
### original version
```
$ mv mv1.mp4 /media/movies
$ export XDG_RUNTIME_DIR=/run/user/root 
$ chmod +x scripts.sh
$ ./scripts
```  

### cpu isolation version
```
$ mv mp1.mp4 /media/movies
$ export XDG_RUNTIME_DIR=/run/user/root
$ chmod +x cpu_isolation.sh
$ chmod +x benchmark_small.sh
$ chmod +x script.sh
# set cpu affinities
./cpu_isolation.sh
# run gpu benchmark and gpu workload processes
./script.sh
```
