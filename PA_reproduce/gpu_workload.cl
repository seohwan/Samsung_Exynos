#define MEM_ACCESS_NUM 1000000000000000

/* Memory */
// __kernel void gpu_workload_high(__global float8* data,
//         __global float8* group_result, int compute_step) {
    
//     float8 f1, f2, f3, f4;
//     float8 tmp[100];
//     float8 d1, d2, d3, d4;
//     int r[MEM_ACCESS_NUM];
//     int w[MEM_ACCESS_NUM];


//     uint global_addr, local_addr;
    
//     global_addr = get_global_id(0);
//     local_addr = get_local_id(0);

//     if(get_local_id(0) == 0) {
//         for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//             r[j] = j;
//         }

//         f1 = data[global_addr];
//         f2 = data[global_addr + 1];
//         f3 = data[global_addr + 2];
//         f4 = data[global_addr + 3];

//         for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//             r[j] = j;
//         }

//         d1 = (float8)(1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f);
//         d2 = (float8)(2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f);
//         d3 = (float8)(3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f);
//         d4 = (float8)(4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f);

//         for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//             r[j] = j;
//         }

//         for(int i = 1; i <= compute_step; i++) {
//             d1 += global_addr;

//             for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//             }
//             d2 += global_addr;
//             for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//             }
//             d3 += global_addr;
//             for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//             }
//             d4 += global_addr;
//             for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//             }
//         }

//         for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//         }
//         group_result[global_addr] = d1;
//         for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//         }
//         group_result[global_addr + 1] = d2;
//         for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//         }
//         group_result[global_addr + 2] = d3;
//         for(long long j = 0; j < MEM_ACCESS_NUM; j++){
//                 r[j] = j;
//         }
//         group_result[global_addr + 3] = d4;
        
//         for(long long i = 0; i < MEM_ACCESS_NUM; i++){
//             w[i] = r[i];
//         }
//     }
    
// }


// /* Read + Write * 1000 */
// __kernel void gpu_workload_high(__global float8* data,
//         __global float8* group_result, int compute_step) {
    
//     float8 f1, f2, f3, f4;
//     float8 tmp[100];
//     float8 d1, d2, d3, d4;
//     uint global_addr, local_addr;
    
//     global_addr = get_global_id(0);
//     local_addr = get_local_id(0);

//     if(get_local_id(0) == 0) {
//         for(int it = 0; it < 1000; it++){
//             f1 = data[global_addr];
//             f2 = data[global_addr + 1];
//             f3 = data[global_addr + 2];
//             f4 = data[global_addr + 3];

//             f4 = data[global_addr];
//             f3 = data[global_addr + 1];
//             f2 = data[global_addr + 2];
//             f1 = data[global_addr + 3];
//         }
//         // f1 = data[global_addr];
//         // f2 = data[global_addr + 1];
//         // f3 = data[global_addr + 2];
//         // f4 = data[global_addr + 3];

//         d1 = (float8)(1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f);
//         d2 = (float8)(2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f);
//         d3 = (float8)(3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f);
//         d4 = (float8)(4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f);

//         for(int i = 1; i <= compute_step; i++) {
//             d1 += global_addr;
//             d2 += global_addr;
//             d3 += global_addr;
//             d4 += global_addr;
//         }

//         for(int it = 0; it < 1000; it++){
//             group_result[global_addr] = d4;
//             group_result[global_addr + 1] = d3;
//             group_result[global_addr + 2] = d2;
//             group_result[global_addr + 3] = d1;

//             group_result[global_addr] = d1;
//             group_result[global_addr + 1] = d2;
//             group_result[global_addr + 2] = d3;
//             group_result[global_addr + 3] = d4;
//         }        

//         // group_result[global_addr] = d1;
//         // group_result[global_addr + 1] = d2;
//         // group_result[global_addr + 2] = d3;
//         // group_result[global_addr + 3] = d4;
        
//     }
// }


/* Synthetic workload */
__kernel void gpu_workload_high(__global float8* data,
        __global float8* group_result, int compute_step) {
    
    float8 f1, f2, f3, f4;
    float8 d1, d2, d3, d4;
    uint global_addr, local_addr;
    
    global_addr = get_global_id(0);
    local_addr = get_local_id(0);

    if(get_local_id(0) == 0) {
        f1 = data[global_addr];
        f2 = data[global_addr + 1];
        f3 = data[global_addr + 2];
        f4 = data[global_addr + 3];

        d1 = (float8)(1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f);
        d2 = (float8)(2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f);
        d3 = (float8)(3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f);
        d4 = (float8)(4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f);

        for(int i = 1; i <= compute_step; i++) {
            d1 += global_addr;
            d2 += global_addr;
            d3 += global_addr;
            d4 += global_addr;
        }
    
        group_result[global_addr] = d1;
        group_result[global_addr + 1] = d2;
        group_result[global_addr + 2] = d3;
        group_result[global_addr + 3] = d4;
    }
    
}

__kernel void gpu_workload_low(__global float8* data,
        __global float8* group_result, int compute_step) {
    float8 d1, d2, d3, d4;
    uint global_addr, local_addr;
    
    global_addr = get_global_id(0);
    local_addr = get_local_id(0);

    if(get_local_id(0) == 0) {        
        d1 = (float8)(1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f, 1.0f);
        d2 = (float8)(2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f, 2.0f);
        d3 = (float8)(3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f, 3.0f);
        d4 = (float8)(4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f, 4.0f);

        for(int i = 1; i <= compute_step; i++) {
            d1 += global_addr;
            d2 += global_addr;
            d3 += global_addr;
            d4 += global_addr;
        }
        
    }
    if(global_addr==0) group_result[global_addr] = d1;    
}