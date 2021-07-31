#!/bin/sh

# mp3[b,m]  run_workload 1 1 ...
# mp3[b], mp3[m] run_workload 1 0 ...

# flag to run benchmark only
#BENCHMARK_ONLY

# parameters
glmark2_small=benchmark_small.sh
cpus_benchmark=4
cpus_system=0
cpus_workload=1

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

	# for loop doesn't work
	#for ((i=0;i<1;i++)); do

		# move tasks back to root cpuset
		if [ -d "/cpuset/benchmark" ]
		then
			for T in `cat /cpuset/benchmark/tasks`; do echo "Moving " $T; /bin/echo $T > /cpuset/tasks; done
			rmdir /cpuset/benchmark
		fi

		# cpuset benchmark
		mkdir /cpuset/benchmark
		echo $cpus_benchmark > /cpuset/benchmark/cpuset.cpus
		
		echo 1 > /cpuset/benchmark/cpuset.cpu_exclusive
		echo 0 > /cpuset/benchmark/cpuset.mems
		echo 1 > /cpuset/benchmark/cpuset.mem_hardwall

		# move all processes to cpus_system
		echo "Moving all processes to core $cpus_system"
		for i in `cat /cpuset/tasks`; do taskset -cp $cpus_system $i; done 	

		# run gpu workload
		./run.sh ${workload_instance} ${version} ${step} ${read} ${write} ${sleep}
 
		# move workload processes to cpus_workload
		  #for i in $(pidof test); do echo $i > /cpuset/workload/tasks; done &
		echo "Moving workload process to core $cpus_workload"
		for i in $(pidof test); do taskset -cp $cpus_workload $i; done 


		# write terminal PID to /cpuset/benchmark
		echo $$ > /cpuset/benchmark/tasks

		# run glmark2
		  #MALI_INSTANCE=$benchmark_instance ../${glmark2_small} >> ${output_txt} &
		MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland >> ${output_txt} 
		
		  #while [ $(pidof glmark2-es2-wayland) ]; do true; done &&
		  #echo PID: $(pidof glmark2-es2-wayland)
		  #echo $(pidof glmark2-es2-wayland) > /cpuset/benchmark/tasks &&
		
		# wait (or sleep?) until glmark2 is finished 
		# waiting generates overhead
		  #while [ $(pidof glmark2-es2-wayland) ]; do true; done
		  #sleep 360		

		# kill gpu workload tasks and benchmark if not killed
		if [ $(pidof test) ]; then 
			echo "kill gpu workload processes"
			kill -9 $(pidof test)
		fi
		if [ $(pidof glmark2-es2-wayland) ]; then
			kill -9 $(pidof glmark2-es2-wayland)
		fi 
		
		sleep 10
	#done
}


# mount cpuset for the first time
if [ ! -d "/cpuset" ]
then
	mkdir /cpuset
	mount -t cpuset none /cpuset/
fi

# kill processes before running next experiment
kill -9 $(pidof test)
kill -9 $(pidof glmark2-es2-wayland)


# 128KB, 0.2s
src=/home/root/test/cpu_isolation/128KB
cd $src
make
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 2 ${src}
run_workload 1 0 1 1500 1 1 2 ${src}
# read 0 write 0
run_workload 1 1 1 1500 0 0 2 ${src}
run_workload 1 0 1 1500 0 0 2 ${src}
sleep 60



