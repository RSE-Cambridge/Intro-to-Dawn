#!/bin/bash

echo "Starting torchrun: "
echo " --nnodes=$SLURM_NNODES"
echo " --node_rank=$SLURM_NODEID"
echo " --rdzv_id=$SLURM_JOB_ID"
echo "--rdzv_endpoint=$MASTER_ADDR:$MASTER_PORT"

time torchrun \
     --nnodes=$SLURM_NNODES \
     --nproc_per_node=8 \
     --node_rank=$SLURM_NODEID \
     --rdzv_id=$SLURM_JOB_ID \
     --master_addr=$MASTER_ADDR \
     --master_port=$MASTER_PORT \
     --rdzv_endpoint=$MASTER_ADDR:$MASTER_PORT \
     fsdp_torchrun5.py  --epochs 100
