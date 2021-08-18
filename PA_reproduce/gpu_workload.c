#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>
#include <CL/cl.h>

#define PROGRAM_FILE "gpu_workload.cl"
#define KERNEL_FUNC_HIGH "gpu_workload_high"
#define KERNEL_FUNC_LOW "gpu_workload_low"
#define LOCAL_SIZE 4

#define LOW_MEM_ACCESS 0
#define HIGH_MEM_ACCESS 1

static unsigned long long cnt = 0;

void sig_handler(int signum){
   if(signum == SIGKILL || signum == SIGSTOP || signum == SIGQUIT || signum == SIGINT || signum == 9){
      printf("[STATUS] cnt: %lu\n", cnt);
   }
}


/* Find a GPU or CPU associated with the first available platform */ 
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
   /* Parameters */
   cl_int compute_step = 0;
   cl_int mem_access_step = 0;
   unsigned long long arg_data_size = 0;
   int mem_access_amount = 0;

   if(argc == 4) {
      compute_step = atoi(argv[1]);
      mem_access_amount = atoi(argv[2]);
      arg_data_size = atoi(argv[3]);
   } else {
      printf("Usage : ./test <compute_step> <mem_access_amount> <data_size(bytes)>");
      exit(1);
   }

   signal(SIGKILL, sig_handler);
   signal(SIGINT, sig_handler);
   signal(SIGSTOP, sig_handler);
   signal(SIGQUIT, sig_handler);
   signal(9, sig_handler);

   /* OpenCL structures */
   cl_device_id device;
   cl_context context;
   cl_program program;
   cl_kernel kernel;
   cl_command_queue queue;
   cl_int err;
   size_t local_size, global_size;
   cl_mem input_buffer, output_buffer;
 
   unsigned long long alloc_array_size = arg_data_size / sizeof(float);
   global_size = alloc_array_size / 8;
   local_size = LOCAL_SIZE;

   float* data;
   float* result;
   data = (float *)malloc(alloc_array_size*sizeof(float));
   result = (float *)malloc(alloc_array_size*sizeof(float));


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

   /* Create a command queue */
   queue = clCreateCommandQueue(context, device, 0, &err);
   if(err < 0) {
         perror("Couldn't create a command queue");
         printf("err # : %d\n", err);
         exit(1);
   }

   FILE *fp = fopen("/media/movies/mv1.mp4", "r");
   if(fp == NULL){
      printf("cannot open file\n");
      exit(1);
   }

   while(1) {
      while(1){
         fp = fopen("/media/movies/mv1.mp4", "r");
         if(fp == NULL){
            printf("cannot open file\n");            
         }
         else{
            break;
         }
      }
      fread(data, sizeof(float), alloc_array_size, fp);

      /* Create data buffer */
      input_buffer = clCreateBuffer(context, CL_MEM_READ_ONLY | 
            CL_MEM_COPY_HOST_PTR, alloc_array_size * sizeof(float), data, &err); // <===== INPUT
      output_buffer = clCreateBuffer(context, CL_MEM_READ_WRITE |      
            CL_MEM_COPY_HOST_PTR, alloc_array_size * sizeof(float), result, &err); // <===== OUTPUT
      if(err < 0) {
         perror("Couldn't create a buffer");
         printf("err # : %d\n", err);
         exit(1);
      }

      /* Create a kernel */
      if(mem_access_amount == HIGH_MEM_ACCESS) {
         kernel = clCreateKernel(program, KERNEL_FUNC_HIGH, &err);
      }
      else if(mem_access_amount == LOW_MEM_ACCESS) {
         kernel = clCreateKernel(program, KERNEL_FUNC_LOW, &err);
      }
      else {
         printf("not allowed option\n");
         exit(1);         
      }
      
      if(err < 0) {
         perror("Couldn't create a kernel");
         printf("err # : %d\n", err);
         exit(1);
      }      

      /* Create kernel arguments */
      err = clSetKernelArg(kernel, 0, sizeof(cl_mem), &input_buffer); // <=====INPUT
      err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), &output_buffer); // <=====OUTPUT
      err |= clSetKernelArg(kernel, 2, sizeof(cl_int), &compute_step);

      if(err < 0) {
         perror("Couldn't create a kernel argument");
         perror("Couldn't create a kernel");
         exit(1);
      }   

      err = clEnqueueNDRangeKernel(queue, kernel, 1, NULL, &global_size,
            &local_size, 0, NULL, NULL);

      if(err < 0) {
         perror("Couldn't enqueue the kernel");
         printf("context # : %d\n", err);
         exit(1);
      }
      
      /* Read the kernel's output */
      // enqueue commands to read from a buffer object to host memory
      err = clEnqueueReadBuffer(queue, output_buffer, CL_TRUE, 0,
            sizeof(result), result, 0, NULL, NULL); // <===== GET OUTPUT
      if(err < 0) {
         perror("Couldn't read the buffer");
         printf("err #: %d\n", err);
         exit(1);
      }   

      clReleaseKernel(kernel);
      clReleaseMemObject(output_buffer);
      clReleaseMemObject(input_buffer); 

      fclose(fp);
      cnt++;
   }

   /* Deallocate resources */
   clReleaseCommandQueue(queue);
   clReleaseProgram(program);
   clReleaseContext(context);

   free(data);
   free(result);
   return 0;
}