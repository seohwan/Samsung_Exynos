#!/bin/sh

benchmark_duration=5000
iteration=5

function initialize(){
    # turn off processes 
    kill -9 $(pidof glmark2-es2-wayland)
    kill -9 $(pidof rse-compositor)
    kill -9 $(pidof test)
    /home/root/discovery-off.sh
    systemctl stop discovery_rse2.service
    sleep 2
}

function run_benchmark_only(){
    benchmark_instance=$1
    output_txt=OB.txt

    initialize

    for ((i=0;i<${iteration};i++)); do
        echo "[STATUS]  - Benchmark `expr $i + 1`/${iteration} "
        MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b texture:texture-filter=nearest:duration=${benchmark_duration} >> ${output_txt} 

        kill -9 $(pidof glmark2-es2-wayland)		
        
        echo "[RESULT]"
        cat $output_txt | grep Score > .tmp_out
        tail -1 .tmp_out
        sleep 2
    done
}

function run(){
    benchmark_instance=$1
    workload_instance=$2
    workload=$3

    initialize

    if [ $benchmark_instance -eq $workload_instance ]; then
        output_txt=N.txt
        status='Non Separation'
    else
        output_txt=S.txt
        status='Separation'
    fi

    echo "[STATUS] Starting 5 ${workload} processes (GPU : ${workload_instance})"
    
    if [ $workload == 'V' ]; then
        MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' & 
        MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &    
        MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &    
        MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &    
        MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &    
    
        sleep 30
        echo "Run benchmark in 5 seconds...."
        sleep 5
    elif [ $workload == 'A' ]; then 
        MALI_INSTANCE=$workload_instance systemctl start discovery_app1.service
        MALI_INSTANCE=$workload_instance systemctl start discovery_app2.service
        MALI_INSTANCE=$workload_instance systemctl start discovery_app3.service
        MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &
        MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &

        echo "Run benchmark in 13 seconds...."
        sleep 13
    elif [ $workload == 'S' ]; then 
        make
        data_size=`expr 1 \* 1 \* 512` # byte
        for ((j=0;j<5;j++)); do
            MALI_INSTANCE=$workload_instance ./test 1 1 $data_size &
        done
    else
        echo "Invalid workload"
    fi


    for ((i=0;i<${iteration};i++)); do
        echo "[STATUS]  - $status `expr $i + 1`/${iteration} "
        MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b texture:texture-filter=nearest:duration=${benchmark_duration} >> ${output_txt} 

        kill -9 $(pidof glmark2-es2-wayland)		
        
        echo "[RESULT]"
        cat $output_txt | grep Score > .tmp_out
        tail -1 .tmp_out
        sleep 2
    done

    sleep 2
}

# echo "# Only Benchmark" 
# benchmark_instance=0
# run_benchmark_only $benchmark_instance


initialize

# echo "######## Experiment : B + 5A ##########"
# # B + 5A
# workload=A

# # Non Separation
# benchmark_instance=0
# workload_instance=0
# run $benchmark_instance $workload_instance $workload

# # Separation
# benchmark_instance=0
# workload_instance=1
# run $benchmark_instance $workload_instance $workload


# echo "######## Experiment : B + 5V ##########"
# # B + 5V
# workload=V

# # Non Separation
# benchmark_instance=0
# workload_instance=0
# run $benchmark_instance $workload_instance $workload

# # Separation
# benchmark_instance=0
# workload_instance=1
# run $benchmark_instance $workload_instance $workload


echo "######## Experiment : B + 5S ##########"
# B + 5S
workload=S

# Non Separation
benchmark_instance=0
workload_instance=0
run $benchmark_instance $workload_instance $workload

# # Separation
# benchmark_instance=0
# workload_instance=1
# run $benchmark_instance $workload_instance $workload