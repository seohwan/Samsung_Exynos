on run_workload(){
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
	make
	chmod +x test
	output_txt=${src}/out/b${benchmark_instance}_m${workload_instance}_${read}_${write}_${sleep}.txt
	echo "writing ${output_txt}"

	for ((i=0;i<5;i++)); do
	#for ((i=0;i<2;i++)); do
		./run.sh ${workload_instance} ${version} ${step} ${read} ${write} ${sleep} &
		MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland >> ${output_txt} ;
		#MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b shading:duration=5.0 >> ${output_txt};
		
		kill -9 $(pidof test) &&
		kill -9 $(pidof glmark2-es2-wayland) &&
		echo "kill gpu workload processes"
		sleep 10
	done

	sleep 300
	#sleep 3 
}

# mp3[b,m]  run_workload 1 1 
# mp3[b], mp3[m] run_workload 1 0

src=/home/root/test/1MB
mkdir ${src}/out
# input size : 1MB (10h)
# read 0 write 0
#run_workload 1 1 1 1500 0 0 10 ${src}
#run_workload 1 0 1 1500 0 0 10 ${src}
#sleep 600
run_workload 1 1 1 1500 0 0 20 ${src}
run_workload 1 0 1 1500 0 0 20 ${src}
sleep 600
run_workload 1 1 1 1500 0 0 30 ${src}
run_workload 1 0 1 1500 0 0 30 ${src}

# read 1 write 0
run_workload 1 1 1 1500 1 0 10 ${src}
run_workload 1 0 1 1500 1 0 10 ${src}
#sleep 600
run_workload 1 1 1 1500 1 0 20 ${src}
run_workload 1 0 1 1500 1 0 20 ${src}
sleep 600
run_workload 1 1 1 1500 1 0 30 ${src}
run_workload 1 0 1 1500 1 0 30 ${src}

# read 1 write 0
run_workload 1 1 1 1500 1 0 10 ${src}
run_workload 1 0 1 1500 1 0 10 ${src}
sleep 600
# read 1 write 1 
run_workload 1 1 1 1500 1 1 10 ${src}  // 30 min
run_workload 1 0 1 1500 1 1 10 ${src} 
sleep 600
# read 0 write 1
run_workload 1 1 1 1500 0 1 10 ${src}
run_workload 1 0 1 1500 0 1 10 ${src}

run_workload 1 1 1 1500 1 1 20 ${src}
run_workload 1 0 1 1500 1 1 20 ${src}
sleep 600
run_workload 1 1 1 1500 1 1 30 ${src}
run_workload 1 0 1 1500 1 1 30 ${src}

sleep 600
run_workload 1 1 1 1500 1 0 20 ${src}
run_workload 1 0 1 1500 1 0 20 ${src}
sleep 600
run_workload 1 1 1 1500 1 0 30 ${src}
run_workload 1 0 1 1500 1 0 30 ${src}


sleep 600
run_workload 1 1 1 1500 0 1 20 ${src}
run_workload 1 0 1 1500 0 1 20 ${src}
sleep 600
run_workload 1 1 1 1500 0 1 30 ${src}
run_workload 1 0 1 1500 0 1 30 ${src}


src=/home/root/test/500KB
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 10 ${src}
run_workload 1 0 1 1500 1 1 10 ${src} 
sleep 600
run_workload 1 1 1 1500 1 1 20 ${src}
run_workload 1 0 1 1500 1 1 20 ${src}
sleep 600
run_workload 1 1 1 1500 1 1 30 ${src}
run_workload 1 0 1 1500 1 1 30 ${src}

# read 1 write 0
run_workload 1 1 1 1500 1 0 10 ${src}
run_workload 1 0 1 1500 1 0 10 ${src}
sleep 600
run_workload 1 1 1 1500 1 0 20 ${src}
run_workload 1 0 1 1500 1 0 20 ${src}
sleep 600
run_workload 1 1 1 1500 1 0 30 ${src}
run_workload 1 0 1 1500 1 0 30 ${src}

# read 0 write 1
run_workload 1 1 1 1500 0 1 10 ${src}
run_workload 1 0 1 1500 0 1 10 ${src}
sleep 600
run_workload 1 1 1 1500 0 1 20 ${src}
run_workload 1 0 1 1500 0 1 20 ${src}
sleep 600
run_workload 1 1 1 1500 0 1 30 ${src}
run_workload 1 0 1 1500 0 1 30 ${src}

# read 0 write 0
run_workload 1 1 1 1500 0 0 10 ${src}
run_workload 1 0 1 1500 0 0 10 ${src}
sleep 600
run_workload 1 1 1 1500 0 0 20 ${src}
run_workload 1 0 1 1500 0 0 20 ${src}
sleep 600
run_workload 1 1 1 1500 0 0 30 ${src}
run_workload 1 0 1 1500 0 0 30 ${src}
sleep 600

src=/home/root/test/125KB
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 10 ${src}
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
sleep 600

sleep 1200

src=/home/root/test/1500KB
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 1500 1 1 10 ${src}
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
sleep 600

sleep 1200

src=/home/root/test/1MB_step5000
mkdir ${src}/out
# read 1 write 1 
run_workload 1 1 1 5000 1 1 10 ${src}
run_workload 1 0 1 5000 1 1 10 ${src} 
sleep 600
run_workload 1 1 1 5000 1 1 20 ${src}
run_workload 1 0 1 5000 1 1 20 ${src}
sleep 600
run_workload 1 1 1 5000 1 1 30 ${src}
run_workload 1 0 1 5000 1 1 30 ${src}
sleep 600

# read 1 write 0
run_workload 1 1 1 5000 1 0 10 ${src}
run_workload 1 0 1 5000 1 0 10 ${src}
sleep 600
run_workload 1 1 1 5000 1 0 20 ${src}
run_workload 1 0 1 5000 1 0 20 ${src}
sleep 600
run_workload 1 1 1 5000 1 0 30 ${src}
run_workload 1 0 1 5000 1 0 30 ${src}
sleep 600

# read 0 write 1
run_workload 1 1 1 5000 0 1 10 ${src}
run_workload 1 0 1 5000 0 1 10 ${src}
sleep 600
run_workload 1 1 1 5000 0 1 20 ${src}
run_workload 1 0 1 5000 0 1 20 ${src}
sleep 600
run_workload 1 1 1 5000 0 1 30 ${src}
run_workload 1 0 1 5000 0 1 30 ${src}
sleep 600

# read 0 write 0
run_workload 1 1 2 5000 0 0 10 ${src}
run_workload 1 0 2 5000 0 0 10 ${src}
sleep 600
run_workload 1 1 2 5000 0 0 20 ${src}
run_workload 1 0 2 5000 0 0 20 ${src}
sleep 600
run_workload 1 1 2 5000 0 0 30 ${src}
run_workload 1 0 2 5000 0 0 30 ${src}
sleep 600



