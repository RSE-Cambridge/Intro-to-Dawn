#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=<FIX_ACCOUNT>
#SBATCH --partition=pvc9  

# --- resources ------------------------------------------------------
#SBATCH --job-name=example3
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1         
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example 3 - This example shows the message in the slurm-<JOB_ID>.out file when the job is killed by slurm.
# for this example change the value to --time=0-0:02:00  
# Use 'bash remove_slurm_files.sh' to delete the slurm files before moving onto the next example.

echo -n "This script is running on "
hostname
sleep 120
