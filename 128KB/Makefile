TARGET = bandhwidth_test

$(TARGET) : gpu_workload.c
	cp -r CL/ /usr/include/
	gcc -o test gpu_workload.c -lOpenCL

clean :
	rm test
