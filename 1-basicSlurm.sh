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
module load rhel9/default-dawn

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example 1 - This example just shows the bare minimum of module loading with a job asking for 1 hour of time.
# It prints "Script is running on <HOSTNAME>" then waits for 15s so you can see it move through status changes in the squeue command.
# You should see that the hostname printed into the slurm*.out file is different to that in your command line prompt

#Use 'bash remove_slurm_files.sh' to delete the slurm files before moving onto the next example

module purge
module load rhel9/default-dawn

echo -n "Script is running on "
hostname
sleep 15
