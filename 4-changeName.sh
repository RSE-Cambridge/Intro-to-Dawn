#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
# job name
#SBATCH --job-name="MoreMeaningfullName"
#SBATCH --time=0-01:00:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example 4 - This example shows how to change the name of a job to something more human readable with the '#SBATCH --job-name <new job name>' option.
# You should see the name of the job change to a cut down version of 'MoreMeaningfullName' in the 'squeue -u ${USER}' output.

#Use 'bash remove_slurm_files.sh' to delete the slurm files before moving onto the next example

echo -n "This script is running on "
hostname
sleep 10
