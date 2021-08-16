#!/bin/sh


function run_workload(){
	workload_instance=$1
	compute_step=$2
	mem_access_amount=$3
	data_size=$4
	src=$5
	iteration=$6
	number_of_synthetic_workload=$7

	cd ${src}
	chmod +x test

    # run gpu workload
    for ((j=1;j<${number_of_synthetic_workload};j++)); do
        MALI_INSTANCE=$workload_instance ./test $compute_step $mem_access_amount $data_size &
    done
    MALI_INSTANCE=$workload_instance ./test $compute_step $mem_access_amount $data_size
}



# kill processes before running next experiment
kill -9 $(pidof test)

compute_step=1
data_size=`expr 1 \* 1 \* 512` # byte
iteration=5 # deprecated
src=/home/root/test/float8_workload
number_of_synthetic_workload=5

cd $src
make
mkdir ${src}/out

workload_instance=1
mem_access_amount=1
run_workload ${workload_instance} ${compute_step} ${mem_access_amount} ${data_size} ${src} ${iteration} ${number_of_synthetic_workload}

