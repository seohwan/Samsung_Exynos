__kernel void gpu_workload_high(__global float8* data,
        __local float8* local_result, __global float8* group_result,
        int highBandwidth, int compute_step) {
    
    float8 f1, f2, f3, f4;
    float8 tmp;
    float divider;
    uint global_addr, local_addr;
    
    global_addr = get_global_id(0);
    local_addr = get_local_id(0);


    if(get_local_id(0) == 0) {
        f1 = data[global_addr];
        f2 = data[global_addr + 1];
        f3 = data[global_addr + 2];
        f4 = data[global_addr + 3];

        local_result[local_addr] = f1;
        local_result[local_addr + 1] = f2;
        local_result[local_addr + 2] = f3;
        local_result[local_addr + 3] = f4;

        for(int i = 0; i < compute_step; i++) {
            
            f1 = local_result[local_addr];
            f2 = local_result[local_addr + 2];
            f3 = local_result[local_addr + 3];
            f4 = local_result[local_addr + 4];

            tmp = f1 * f2;
            tmp /= (f3);
            f1 += tmp / f1;
            f2 += tmp / f2;
            f3 += tmp / f3;
            f4 += tmp / f4;

            if(i % 100 == 0) {
                divider = 10;
                f1 /= divider;
                f2 /= divider;
                f3 /= divider;
                f4 /= divider; 
            }

            local_result[local_addr] = f1;
            local_result[local_addr + 1] = f2;
            local_result[local_addr + 2] = f3;
            local_result[local_addr + 3] = f4;

            group_result[global_addr] = f1;
            group_result[global_addr + 1] = f2;
            group_result[global_addr + 2] = f3;
            group_result[global_addr + 3] = f4;
        }
        


    }
}

__kernel void gpu_workload_mid_read_write(__global float8* data,
        __local float8* local_result, __global float8* group_result,
        int highBandwidth, int compute_step) {
    
    float8 f1, f2, f3, f4;
    float8 tmp;
    float divider;
    uint global_addr, local_addr;
    
    global_addr = get_global_id(0);
    local_addr = get_local_id(0);

    

    if(get_local_id(0) == 0) {
        f1 = data[global_addr];
        f2 = data[global_addr + 1];
        f3 = data[global_addr + 2];
        f4 = data[global_addr + 3];

        for(int i = 1; i <= compute_step; i++) {
            tmp = f1 * f2;
            tmp /= (f3);
            //tmp = f4;
            f1 += tmp / f1;
            f2 += tmp / f2;
            f3 += tmp / f3;
            f4 += tmp / f4;

            if(i % 100 == 0) {
                divider = 10;
                f1 /= divider;
                f2 /= divider;
                f3 /= divider;
                f4 /= divider; 
            }
        }

        group_result[global_addr] = f1;
        group_result[global_addr + 1] = f2;
        group_result[global_addr + 2] = f3;
        group_result[global_addr + 3] = f4;
    }
}

__kernel void gpu_workload_mid_read(__global float8* data,
        __local float8* local_result, __global float8* group_result,
        int highBandwidth, int compute_step) {
    
    float8 f1, f2, f3, f4;
    float8 tmp;
    float divider;
    uint global_addr, local_addr;
    
    global_addr = get_global_id(0);
    local_addr = get_local_id(0);

    if(get_local_id(0) == 0) {
        f1 = data[global_addr];
        f2 = data[global_addr + 1];
        f3 = data[global_addr + 2];
        f4 = data[global_addr + 3];

        for(int i = 1; i <= compute_step; i++) {
            tmp = f1 * f2;
            tmp /= (f3);
            //tmp = f4;
            f1 += tmp / f1;
            f2 += tmp / f2;
            f3 += tmp / f3;
            f4 += tmp / f4;

            if(i % 100 == 0) {
                divider = 10;
                f1 /= divider;
                f2 /= divider;
                f3 /= divider;
                f4 /= divider; 
            }
        }

        //group_result[global_addr] = f1;
        //group_result[global_addr + 1] = f2;
        //group_result[global_addr + 2] = f3;
        //group_result[global_addr + 3] = f4;
    }
        if(global_addr==0) group_result[global_addr] = f1;
    }

__kernel void gpu_workload_mid_write(__global float8* data,
        __local float8* local_result, __global float8* group_result,
        int highBandwidth, int compute_step) {
    
    float8 f1, f2, f3, f4;
    float8 tmp;
    float divider;
    uint global_addr, local_addr;
    
    global_addr = get_global_id(0);
    local_addr = get_local_id(0);


    if(get_local_id(0) == 0) {
        f1 = (float8)(1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f);
        f2 = (float8)(2.0f, 3.0f, 1.0f, 4.0f, 8.0f, 10.0f, 2.0f, 7.0f);
        f3 = (float8)(9.0f, 6.0f, 3.0f, 4.0f, 5.0f, 2.0f, 9.0f, 8.0f);
        f4 = (float8)(3.0f, 2.0f, 4.0f, 5.0f, 8.0f, 1.0f, 2.0f, 5.0f);

        for(int i = 1; i <= compute_step; i++) {
            tmp = f1 * f2;
            tmp /= (f3);
            //tmp = f4;
            f1 += tmp / f1;
            f2 += tmp / f2;
            f3 += tmp / f3;
            f4 += tmp / f4;

            if(i % 100 == 0) {
                divider = 10;
                f1 /= divider;
                f2 /= divider;
                f3 /= divider;
                f4 /= divider; 
            }
        }

        group_result[global_addr] = f1;
        group_result[global_addr + 1] = f2;
        group_result[global_addr + 2] = f3;
        group_result[global_addr + 3] = f4;
    }
}

__kernel void gpu_workload_low(__global float8* data,
        __local float8* local_result, __global float8* group_result,
        int highBandwidth, int compute_step) {
    
    float8 f1, f2, f3, f4;
    float8 tmp;
    float divider;
    uint global_addr, local_addr;
    
    global_addr = get_global_id(0);
    local_addr = get_local_id(0);

    if(get_local_id(0) == 0) {
        f1 = (float8)(1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f, 8.0f);
        f2 = (float8)(2.0f, 3.0f, 1.0f, 4.0f, 8.0f, 10.0f, 2.0f, 7.0f);
        f3 = (float8)(9.0f, 6.0f, 3.0f, 4.0f, 5.0f, 2.0f, 9.0f, 8.0f);
        f4 = (float8)(3.0f, 2.0f, 4.0f, 5.0f, 8.0f, 1.0f, 2.0f, 5.0f);


        for(int i = 1; i <= compute_step; i++) {
            tmp = f1 * f2;
            tmp /= (f3);
            //tmp = f4;
            f1 += tmp / f1;
            f2 += tmp / f2;
            f3 += tmp / f3;
            f4 += tmp / f4;

            if(i % 100 == 0) {
                divider = 10;
                f1 /= divider;
                f2 /= divider;
                f3 /= divider;
                f4 /= divider; 
            }
      }

        //group_result[global_addr] = f1;
        //group_result[global_addr + 1] = f2;
        //group_result[global_addr + 2] = f3;
        //group_result[global_addr + 3] = f4;
    }
    if(global_addr==0) group_result[global_addr] = f1;
}