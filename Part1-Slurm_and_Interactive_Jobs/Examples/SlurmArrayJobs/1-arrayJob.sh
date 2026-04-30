#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=<FIX_ACCOUNT>
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------ 
#SBATCH --job-name "SlurmArrayJob"
#SBATCH --time=0-00:01:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --array=1-10%2
# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information
# Slurm Array Example 1 - This command runs the hostname command in ten different jobs, two at a time. These jobs could all be on different nodes or the same node or any combination between, according to which nodes have availability.
# Notice the different values for the SLURM_JOB_ID, SLURM_ARRAY_JOB_ID and SLURM_ARRAY_TASK_ID
# Use 'bash remove_slurm_files.sh' to delete the slurm files before moving onto the next example

echo "This script is running on:"
echo "Host: $(hostname)"
echo "Time: $(date)"
echo "PWD : $(pwd)"
echo "SLURM_JOB_ID is ${SLURM_JOB_ID}"
echo "SLURM_ARRAY_JOB_ID is ${SLURM_ARRAY_JOB_ID}"
echo "SLURM_ARRAY_TASK_ID is ${SLURM_ARRAY_TASK_ID}"

sleep 4
