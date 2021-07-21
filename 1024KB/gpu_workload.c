#define PROGRAM_FILE "gpu_workload.cl"
#define KERNEL_FUNC_HIGH "gpu_workload_high"
#define KERNEL_FUNC_MID_READ_WRITE "gpu_workload_mid_read_write"
#define KERNEL_FUNC_MID_READ "gpu_workload_mid_read"
#define KERNEL_FUNC_MID_WRITE "gpu_workload_mid_write"
#define KERNEL_FUNC_LOW "gpu_workload_low"
// one pixel (RGB) * 1920*1080 = 6MB for a screen shot
#define ARRAY_SIZE 256000 // 1024KB
#define GLOBAL_SIZE 32000  // ARRAY_SIZE / 8
#define LOCAL_SIZE 4

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <CL/cl.h>

/* Find a GPU or CPU associated with the first available platform 

The `platform` structure identifies the first platform identified by the 
OpenCL runtime. A platform identifies a vendor's installation, so a system 
may have an NVIDIA platform and an AMD platform. 

The `device` structure corresponds to the first accessible device 
associated with the platform. Because the second parameter is 
`CL_DEVICE_TYPE_GPU`, this device must be a GPU.
*/
cl_device_id create_device() {

   cl_platform_id platform;
   cl_device_id dev;
   int err;

   /* Identify a platform */
   err = clGetPlatformIDs(1, &platform, NULL);
   if(err < 0) {
      perror("Couldn't identify a platform");
      exit(1);
   } 

   // Access a device
   // GPU
   err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 1, &dev, NULL);
   printf("Return from clGetDeviceIDs: %d\n", err);
   if(err == CL_DEVICE_NOT_FOUND) {
      // CPU
      err = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 1, &dev, NULL);
   }
   if(err < 0) {
      perror("Couldn't access any devices");
      exit(1);   
   }

   return dev;
}

/* Create program from a file and compile it */
cl_program build_program(cl_context ctx, cl_device_id dev, const char* filename) {

   cl_program program;
   FILE *program_handle;
   char *program_buffer, *program_log;
   size_t program_size, log_size;
   int err;

   /* Read program file and place content into buffer */
   program_handle = fopen(filename, "r");
   if(program_handle == NULL) {
      perror("Couldn't find the program file");
      exit(1);
   }
   fseek(program_handle, 0, SEEK_END);
   program_size = ftell(program_handle);
   rewind(program_handle);
   program_buffer = (char*)malloc(program_size + 1);
   program_buffer[program_size] = '\0';
   fread(program_buffer, sizeof(char), program_size, program_handle);
   fclose(program_handle);

   /* Create program from file 

   Creates a program from the source code in the add_numbers.cl file. 
   Specifically, the code reads the file's content into a char array 
   called program_buffer, and then calls clCreateProgramWithSource.
   */
   program = clCreateProgramWithSource(ctx, 1, 
      (const char**)&program_buffer, &program_size, &err);
   if(err < 0) {
      perror("Couldn't create the program");
      exit(1);
   }
   free(program_buffer);

   /* Build program 

   The fourth parameter accepts options that configure the compilation. 
   These are similar to the flags used by gcc. For example, you can 
   define a macro with the option -DMACRO=VALUE and turn off optimization 
   with -cl-opt-disable.
   */
   err = clBuildProgram(program, 0, NULL, NULL, NULL, NULL);
   if(err < 0) {

      /* Find size of log and print to std output */
      clGetProgramBuildInfo(program, dev, CL_PROGRAM_BUILD_LOG, 
            0, NULL, &log_size);
      program_log = (char*) malloc(log_size + 1);
      program_log[log_size] = '\0';
      clGetProgramBuildInfo(program, dev, CL_PROGRAM_BUILD_LOG, 
            log_size + 1, program_log, NULL);
      printf("%s\n", program_log);
      free(program_log);
      exit(1);
   }

   return program;
}

int main(int argc, char *argv[]) {
   /* OpenCL structures */
   int num_context = 500;
   cl_device_id device;
   cl_context context;
   cl_program program;
   cl_kernel kernel;
   cl_command_queue queue;
   cl_int err;
   size_t local_size, global_size;
   cl_mem input_buffer, output_buffer;
   cl_int num_groups;

   time_t start, end;
   double elapsed;
   float result[ARRAY_SIZE];
   float data[ARRAY_SIZE];

   /* Parameters */
   cl_int highBandwidth = 0;
   cl_int compute_step = 0;
   cl_int mem_access_step = 0;
   int read = 0;
   int write = 0;
   int sleep_amount_ = 0;
   float sleep_amount = 0.0;
   int num_finished_kernels = 0;

   if(argc == 6) {
      highBandwidth = atoi(argv[1]);
      compute_step = atoi(argv[2]);
      read = atoi(argv[3]);
      write = atoi(argv[4]);
      sleep_amount_ = atoi(argv[5]); // need to be /10
      sleep_amount = sleep_amount_ / 10.0;
   } else {
      printf("Usage : ./test [0,1,2] <compute_step> <read> <write> <sleep*10>");
      exit(1);
   }
/*
   // Initialize data 
   for(int i = 1; i <= ARRAY_SIZE; i++) {
      data[i] = (i % 13) * 1.0f + 1;
   }
*/

   /* Create a device and context */
   device = create_device();
   context = clCreateContext(NULL, 1, &device, NULL, NULL, &err);
   if (err < 0) {
      perror("Couldn't create a context");
      printf("err # : %d\n", err);
      exit(1);
   }

   /* Build program */
   program = build_program(context, device, PROGRAM_FILE);

   /* Create data buffer */
   global_size = GLOBAL_SIZE;
   local_size = LOCAL_SIZE;
   num_groups = GLOBAL_SIZE / LOCAL_SIZE;


   /* Create a command queue */
   queue = clCreateCommandQueue(context, device, 0, &err);
   if(err < 0) {
         perror("Couldn't create a command queue");
         printf("err # : %d\n", err);
         exit(1);
   }

   // 0721
   pid_t pid;
   cl_event read_event;


   /* Enqueue kernel
   
      At this point, the application has created all the data structures 
      (device, kernel, program, command queue, and context) needed by an
      OpenCL host applications. Now, it deploys the kernel to a device.

      clEnqueueNDRangeKernel is probably the most important to understand.
      Not only does it deploy kernels to devices, it also identifies how many
      work-items should be generated to execute the kernel (global_size) and 
      number of work-items in each work-group (local_size). 
   */
   FILE *fp = fopen("/media/movies/mv1.mp4", "r");
   if(fp == NULL){
      printf("cannot open file\n");
      exit(1);
   }
   int cnt = 0;
   while(1) {
      if(feof(fp) != 0) {
         //printf("open new file\n");
         fp = fopen("/media/movies/mv1.mp4", "r");
         if(fp == NULL){
            printf("cannot open file\n");
            exit(1);
         }
      }
      cnt++;
      fread(data, sizeof(float), ARRAY_SIZE, fp);

      /* Create data buffer */
      /*
         CL_MEM_COPY_HOST_PTR : copies the data pointed to by the host_ptr argument into
         memory allocated by the driver.
      */
      input_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY | 
            CL_MEM_COPY_HOST_PTR, ARRAY_SIZE * sizeof(float), data, &err); // <===== INPUT
      output_buffer = clCreateBuffer(context, CL_MEM_READ_WRITE |
            CL_MEM_COPY_HOST_PTR, ARRAY_SIZE * sizeof(float), result, &err); // <===== OUTPUT
      if(err < 0) {
         perror("Couldn't create a buffer");
         printf("err # : %d\n", err);
         exit(1);
      }

      /* Create a kernel */
      if(highBandwidth == 0) {
         kernel = clCreateKernel(program, KERNEL_FUNC_HIGH, &err);
      } else if(highBandwidth == 1) {
         if(read == 1 && write == 1) {
            kernel = clCreateKernel(program, KERNEL_FUNC_MID_READ_WRITE, &err);
         } else if(read == 1 && write == 0) {
            kernel = clCreateKernel(program, KERNEL_FUNC_MID_READ, &err);
         } else if(read == 0 && write == 1) {
            kernel = clCreateKernel(program, KERNEL_FUNC_MID_WRITE, &err);
         } else if(read == 0 && write == 0) {
            kernel = clCreateKernel(program, KERNEL_FUNC_LOW, &err);
         } else {
            printf("not allowed option\n");
            exit(1);
         }
      } else if(highBandwidth == 2) {
            printf("not allowed option. use 1 <step> 0 0 instead. \n");
            exit(1);      }
      if(err < 0) {
         perror("Couldn't create a kernel");
         printf("err # : %d\n", err);
         exit(1);
      }      

      /* Create kernel arguments */
      err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &input_buffer); // <=====INPUT
      err |= clSetKernelArg(kernel, 1, ARRAY_SIZE / GLOBAL_SIZE * LOCAL_SIZE * sizeof(float), NULL);
      err |= clSetKernelArg(kernel, 2, sizeof(cl_mem), &output_buffer); // <=====OUTPUT
      err |= clSetKernelArg(kernel, 3, sizeof(cl_int), &highBandwidth);
      err |= clSetKernelArg(kernel, 4, sizeof(cl_int), &compute_step);

      if(err < 0) {
         perror("Couldn't create a kernel argument");
         perror("Couldn't create a kernel");
         exit(1);
      }   
         cl_event event;
         cl_ulong time_submit;

         usleep(sleep_amount*1000000);
         printf("queue kernel\n");
         start = time(NULL);
         err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_size,
               &local_size, 0, NULL, &event);

         clFlush(queue);
            
         if(err < 0) {
            perror("Couldn't enqueue the kernel");
            printf("context # : %d\n", err);
            exit(1);
         }

         end = time(NULL); 
         elapsed = (double)(end - start);
         //printf("Elapsed time : %f\n", elapsed);
      //}

   }
   // err = clEnqueueMarker(queue, &stop);
   // clFinish(queue);

   /* Deallocate resources */
   clReleaseKernel(kernel);
   clReleaseMemObject(output_buffer);
   clReleaseMemObject(input_buffer);   
   clReleaseCommandQueue(queue);
   clReleaseProgram(program);
   clReleaseContext(context);

   return 0;
}