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
	output_txt=./b${benchmark_instance}_v${workload_instance}.txt

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
		#./run.sh ${workload_instance} ${version} ${step} ${read} ${write} ${sleep}
		./run_video.sh ${workload_instance}
		
 
		# move workload processes to cpus_workload
		echo "Moving workload process to core $cpus_workload"
		for i in $(pidof rse-compositor); do taskset -cp $cpus_workload $i; done 


		# write terminal PID to /cpuset/benchmark
		echo $$ > /cpuset/benchmark/tasks

		# run glmark2
		MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland >> ${output_txt} 
		
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


# b1 v1
run_workload 1 1
run_workload 1 1

# b1 v0
run_workload 1 0
run_workload 1 0
