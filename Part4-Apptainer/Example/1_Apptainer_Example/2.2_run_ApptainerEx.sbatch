#!/bin/bash 
# --- account ------------------------------------------------------
#SBATCH --account=<FIX_ACCOUNT>
#SBATCH --qos=<FIX_QOS>
#SBATCH --partition=<FIX_PARTITION> 
#SBATCH --mail-type=begin          # send email when job begins
#SBATCH --mail-type=end            # send email when job ends
#SBATCH --mail-user=<FIX_EMAIL>

# --- resources ------------------------------------------------------
#SBATCH --nodes=1                   # node count Normally set to 1 unless
                                    # you require multi-node, multi-GPU
#SBATCH --job-name="ApptEx1-run-sif" # create a short name for your job  
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
echo "  --writable-tmpfs"  
echo "    during the %test section, makes the file system accessible "
echo "    as read-write with non persistent data (with overlay support only)"

# --- run ------------------------------------------------------------
CMD="apptainer run --writable-tmpfs ApptainerEx.sif"
echo "${CMD}"
eval ${CMD}


