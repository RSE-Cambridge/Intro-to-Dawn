#!/bin/bash
# --- account ------------------------------------------------------
#SBATCH --account=<FIX_ME>      # Only required if you are a member of more than one Dawn project
#SBATCH --partition=pvc9  
#SBATCH --mail-type=begin          # send email when job begins
#SBATCH --mail-type=end            # send email when job ends
#SBATCH --mail-user=<FIX_ME>

# --- resources ------------------------------------------------------
#SBATCH --nodes=1                   # node count Normally set to 1 unless
                                    # you require multi-node, multi-GPU
#SBATCH --job-name="ApptEx-run-sif" # create a short name for your job  
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --cpus-per-task=24          # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                # number of allocated gpus per node
#SBATCH --time=00:15:00             # Time assigned for the simulation
                                    #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn  
 
# Exit at first failure.
set -e

# --- run ------------------------------------------------------------
CMD="apptainer run --writable-tmpfs ApptainerEx.sif"
echo "${CMD}"
eval ${CMD}


