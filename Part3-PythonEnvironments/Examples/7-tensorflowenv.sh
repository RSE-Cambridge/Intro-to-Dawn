#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=FIX_THIS
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example6-tensorflow
#SBATCH --time=0-00:55:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn