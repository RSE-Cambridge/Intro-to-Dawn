#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example1
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn
module load intelpython
# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example 1 - This example just shows the bare minimum of module loading
#  It loads the module which has been provided by us for intelpython with conda

module purge
module load rhel9/default-dawn
module load intelpython-conda/2025.0
conda info --envs

echo -n "Script is running on "
hostname

sleep 15
