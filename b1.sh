#!/bin/sh
cpus_benchmark=4
cpus_system=0
benchmark_instance=1
output_txt=b1_out.txt
glmark2_small=benchmark_small.sh

function run_b1(){

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

		# write terminal PID to /cpuset/benchmark
		echo $$ > /cpuset/benchmark/tasks

		# run glmark2
		#MALI_INSTANCE=$benchmark_instance ./${glmark2_small} >> ${output_txt} 
		MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland >> ${output_txt} 
		

	sleep 5

	if [ $(pidof glmark2-es2-wayland) ]
	then
		kill -9 $(pidof glmark2-es2-wayland)
	fi

}

# mount cpuset for the first time
if [ ! -d "/cpuset" ]
then
	mkdir /cpuset
	mount -t cpuset none /cpuset/
fi


run_b1
run_b1