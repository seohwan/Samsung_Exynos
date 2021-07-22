#!/bin/sh

glmark2_small=benchmark_small.sh

function run_workload(){
	benchmark_instance=$1
	workload_instance=$2
	version=$3
	step=$4
	read=$5
	write=$6
	sleep=$7
	src=$8
	cd ${src}
	chmod +x run.sh
	#make
	chmod +x test
	output_txt=${src}/out/b${benchmark_instance}_m${workload_instance}_${read}_${write}_${sleep}.txt
	echo "writing ${output_txt}"

	for ((i=0;i<3;i++)); do
		# run gpu workload on cpu 1
		./run.sh ${workload_instance} ${version} ${step} ${read} ${write} ${sleep} 
		for i in $(pidof test); do echo $i > /cpuset/workload/tasks; done &

		# run glmark2 on cpu 4
		MALI_INSTANCE=$benchmark_instance ../${glmark2_small} >> ${output_txt} &
		sleep 0.5 
		#while [ $(pidof glmark2-es2-wayland) ]; do true; done &&
		echo PID: $(pidof glmark2-es2-wayland)
		echo $(pidof glmark2-es2-wayland) > /cpuset/benchmark/tasks &&
		# wait until glmark2 is finished
		while [ $(pidof glmark2-es2-wayland) ]; do true; done

		# kill gpu workload tasks
		kill -9 $(pidof test) &&
		kill -9 $(pidof glmark2-es2-wayland) &&
		echo "kill gpu workload processes"
		sleep 10

	done

	#sleep 3 
}

# mp3[b,m]  run_workload 1 1 
# mp3[b], mp3[m] run_workload 1 0

src=/home/root/test/cpu_isolation/1024KB
cd $src
make
mkdir ${src}/out
# input size : 1024KB (20 min)
# read 1 write 1 
run_workload 1 1 1 1500 1 1 30 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 30 ${src} 

# read 0 write 0
run_workload 1 1 1 1500 0 0 30 ${src}
run_workload 1 0 1 1500 0 0 30 ${src}


src=/home/root/test/cpu_isolation/512KB
cd $src
make
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 30 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 30 ${src} 

# read 0 write 0
run_workload 1 1 1 1500 0 0 30 ${src}
run_workload 1 0 1 1500 0 0 30 ${src}

src=/home/root/test/cpu_isolation/256KB
cd $src
make
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 30 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 30 ${src} 

# read 0 write 0
run_workload 1 1 1 1500 0 0 30 ${src}
run_workload 1 0 1 1500 0 0 30 ${src}

# 512KB, 1.5s
src=/home/root/test/cpu_isolation/512KB
cd $src
make
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 15 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 15 ${src} 

# read 0 write 0
run_workload 1 1 1 1500 0 0 15 ${src}
run_workload 1 0 1 1500 0 0 15 ${src}

# 512KB, 0.5s
src=/home/root/test/cpu_isolation/512KB
cd $src
make
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 5 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 5 ${src} 

# read 0 write 0
run_workload 1 1 1 1500 0 0 5 ${src}
run_workload 1 0 1 1500 0 0 5 ${src}

# 256KB, 0.5s
src=/home/root/test/cpu_isolation/256KB
cd $src
make
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 5 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 5 ${src} 

# read 0 write 0
run_workload 1 1 1 1500 0 0 5 ${src}
run_workload 1 0 1 1500 0 0 5 ${src}

# 256KB, 0.2s
src=/home/root/test/cpu_isolation/256KB
cd $src
make
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 2 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 2 ${src} 

# read 0 write 0
run_workload 1 1 1 1500 0 0 2 ${src}
run_workload 1 0 1 1500 0 0 2 ${src}



: << "END"
# read 1 write 1 
run_workload 1 1 1 1500 1 1 10 ${src}  // 5min 
run_workload 1 0 1 1500 1 1 10 ${src} 
sleep 600
run_workload 1 1 1 1500 1 1 20 ${src}
run_workload 1 0 1 1500 1 1 20 ${src}
sleep 600
run_workload 1 1 1 1500 1 1 30 ${src}
run_workload 1 0 1 1500 1 1 30 ${src}
sleep 600

# read 1 write 0
run_workload 1 1 1 1500 1 0 10 ${src}
run_workload 1 0 1 1500 1 0 10 ${src}
sleep 600
run_workload 1 1 1 1500 1 0 20 ${src}
run_workload 1 0 1 1500 1 0 20 ${src}
sleep 600
run_workload 1 1 1 1500 1 0 30 ${src}
run_workload 1 0 1 1500 1 0 30 ${src}
sleep 600

# read 0 write 1
run_workload 1 1 1 1500 0 1 10 ${src}
run_workload 1 0 1 1500 0 1 10 ${src}
sleep 600
run_workload 1 1 1 1500 0 1 20 ${src}
run_workload 1 0 1 1500 0 1 20 ${src}
sleep 600
run_workload 1 1 1 1500 0 1 30 ${src}
run_workload 1 0 1 1500 0 1 30 ${src}
sleep 600

# read 0 write 0
run_workload 1 1 1 1500 0 0 10 ${src}
run_workload 1 0 1 1500 0 0 10 ${src}
sleep 600
run_workload 1 1 1 1500 0 0 20 ${src}
run_workload 1 0 1 1500 0 0 20 ${src}
sleep 600
run_workload 1 1 1 1500 0 0 30 ${src}
run_workload 1 0 1 1500 0 0 30 ${src}

END
