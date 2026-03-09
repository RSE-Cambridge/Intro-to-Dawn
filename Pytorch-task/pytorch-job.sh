#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --qos FIX_THIS
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example1
#SBATCH --time=0-01:00:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module purge
module load rhel9/default-dawn
module load intelpython-conda/2025.0

# Run code
python pytorch_gpu.py