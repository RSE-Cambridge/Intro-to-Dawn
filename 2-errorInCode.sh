#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example2
#SBATCH --time=0-01:00:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information
# Example 2 - This example shows what happens when your scripts create an unrecoverable error.
# You should see "ExitCode 1:0" at the bottom of the slurm*.stats file. The number before the colon (:) shows the application's error code

#Use 'bash remove_slurm_files.sh' to delete the slurm files before moving onto the next example

numerator=10
denominator=0
echo $((numerator/denominator)) 

