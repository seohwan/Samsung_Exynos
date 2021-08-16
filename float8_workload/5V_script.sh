#!/bin/sh
kill -9 $(pidof rse-compositor)

echo "####### Experiment :  B + 5A #########"
# 5V
workload=V

workload_instance=1

MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' & 
MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &    
MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &    
MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &    
MALI_INSTANCE=$workload_instance '/opt/rse-demo/rse-compositor' &  