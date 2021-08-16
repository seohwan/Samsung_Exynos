#!/bin/bash

function write_csv(){
	label=$1
	gpu_separation=$2
	dirty_cache=$3

    raw_result=${label}.txt
    pre_scores=${label}.tmp

    # preprocess
    cat ${raw_result} | grep Score >> ${pre_scores}

    while read score_line; do
        score=(${score_line//:/})
        echo ${score[2]}>> ${label}_${gpu_separation}_${dirty_cache}.csv
    done < ${pre_scores}

	rm ${raw_result} ${pre_scores}
}

function run_through(){
	benchmark_instance=$1
	benchmark_duraiton=$2

	output_txt=benchmark_throuth_cpuset_result.txt

	echo "[STATUS] Start Benchmark"
	# run glmark2
	# echo "[build]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b build:use-vbo=false:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[texture]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b texture:texture-filter=nearest:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[shading]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b shading:shading=gouraud:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[bump]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b bump:bump-render=high-poly:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[effect2d]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b effect2d:kernel=0,1,0:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[pulsar]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b pulsar:light=false:quads=5:texture=false:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[desktop]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b desktop:blur-radius=5:effect=blur:passes=1:separable=true:windows=4:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[buffer]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b buffer:columns=200:interleave=false:update-dispersion=0.9:update-fraction=0.5:update-method=map:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[ideas]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b ideas:duration=5.0:speed=duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[jellyfish]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b jellyfish:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)
	# echo "[terrain]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b terrain:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)echo "====================================================="
	# echo "[shaddow]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b shadow:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)echo "====================================================="
	# echo "[refract]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b refract:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)echo "====================================================="
	# echo "[conditionlas]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b conditionals:fragment-steps=0:vertex-steps=0:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)echo "====================================================="
	# echo "[function]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b function:fragment-complexity=low:fragment-steps=5:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-waylandecho "====================================================="
	# echo "[loop]"
	# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b loop:fragment-loop=false:fragment-steps=5:vertex-steps=5:duration=$benchmark_duration
	# kill -9 $(pidof glmark2-es2-wayland)


	#MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland >> ${output_txt} 
		
	if [ $(pidof glmark2-es2-wayland) ]
	then
		kill -9 $(pidof glmark2-es2-wayland)
	fi

	# echo "[RESULT]"
	# cat $output_txt | grep Score > .tmp_out
	# tail -1 .tmp_out
}

function run_benchmark(){
	benchmark_instance=$1
	iteration=$2
	benchmark_duraiton=$3

	output_txt=benchmark_cpuset_result.txt

	for ((i=0;i<${iteration};i++)); do
		echo "[STATUS] Benchmark - `expr $i + 1`/${iteration} "
		# Benchmark
		MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b texture:texture-filter=nearest:duration=${benchmark_duraiton} >> ${output_txt} 

		# Benchmark`
		# MALI_INSTANCE=$benchmark_instance glmark2-es2-wayland -b shading:shading=gouraud:duration=$benchmark_duration >> ${output_txt}		
	
		if [ $(pidof glmark2-es2-wayland) ]
		then
			kill -9 $(pidof glmark2-es2-wayland)
		fi

		echo "[RESULT]"
		cat $output_txt | grep Score > .tmp_out
		tail -1 .tmp_out
	done

	# rm $output_txt
}

kill -9 $(pidof glmark2-es2-wayland)

benchmark_instance=0
iteration=5
benchmark_duraiton=100

# Run 1 Benchmark
run_benchmark ${benchmark_instance} ${iteration} ${benchmark_duraiton}

# modify workload_script.sh, gpu_workload.cl accordingly
# gpu_separation=''
# dirty_cache=''
# write_csv benchmark_cpuset_result ${gpu_separation} ${dirty_cache}


# run_through ${benchmark_instance} ${banchmark_duration}

