#!/bin/bash
# --- account ------------------------------------------------------
#SBATCH --account=<FIX_ME>      
#SBATCH --partition=pvc9   

# --- resources ------------------------------------------------------
#SBATCH --nodes=1                        # node count Normally set to 1 unless
                                         # you require multi-node, multi-GPU
#SBATCH --job-name="INTEL-WandB-run-sif" # create a short name for your job  
#SBATCH --ntasks-per-node=1              # total number of tasks per node
#SBATCH --cpus-per-task=24               # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                     # number of allocated gpus per node
#SBATCH --time=00:15:00                  # Time assigned for the simulation
                                         #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn
 
while IFS= read -r line; do
    echo "HF_TOKEN read from file: $line"
    HF_TOKEN=$line
done < "${HOME}/hugtoken.txt"
export HF_TOKEN

while IFS= read -r line1; do
    echo "WANDB_API_KEY read from file: $line1"
    WANDB_API_KEY=$line1 
done < "${HOME}/wand_api_key.txt"
export WANDB_API_KEY
 
# --- run ------------------------------------------------------------
echo "  --overlay strings"               
echo "    use an overlayFS image for persistent data storage or"
echo "    as read-only layer of container"
apptainer run --overlay Appt_folders "$(pwd -P)/INTEL-WandB.sif" ./test_wandb2.py

# or
echo "  --writable"
echo "    by default all Apptainer containers are available as read only."
echo "    This option makes the file system accessible as read/write"
apptainer run --writable Appt_folders "$(pwd -P)/INTEL-WandB.sif" ./test_wandb2.py



