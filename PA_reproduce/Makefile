TARGET = synthetic_workload

$(TARGET) : gpu_workload.c
	if [ ! -d '/usr/include/CL' ]; then	cp -r CL/ /usr/include/; fi
	gcc -o test gpu_workload.c -lOpenCL

clean :
	rm test
