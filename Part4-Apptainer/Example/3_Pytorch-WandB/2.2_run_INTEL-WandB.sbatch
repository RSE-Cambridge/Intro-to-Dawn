#!/bin/bash
# --- account ------------------------------------------------------
#SBATCH --account=support-gpu      
#SBATCH --partition=pvc9  

# --- resources ------------------------------------------------------
#SBATCH --nodes=1                   # node count Normally set to 1 unless
                                    # you require multi-node, multi-GPU
#SBATCH --job-name="INTEL-WandB-run-sif" # create a short name for your job  
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --cpus-per-task=24          # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                # number of allocated gpus per node
#SBATCH --time=00:45:00             # Time assigned for the simulation
                                    #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn 
module load oneapi-level-zero/1.14/gcc/czctrcfw

# --- run ------------------------------------------------------------
apptainer run --contain --fakeroot --rocm --writable-tmpfs "$(pwd -P)/INTEL-WandB.sif" 



