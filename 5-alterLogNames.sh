#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --qos FIX_THIS
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 


# --- resources ------------------------------------------------------
# job name 
#SBATCH --time=0-01:00:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

#SBATCH --time 1:0:0
#SBATCH --job-name "alterLogNamesTest"
#SBATCH --output=/home/sh824/rds/rds-aswsai/ExperimentLogNames-%j.out  #absolute path protects you from changes in where sbatch is called from

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example 5 - This example shows how to change the name of a job's output, namely the .out and .stats files. Note we've used the absolute path.
# The % codes used in the --output command can be viewed here  https://slurm.schedmd.com/sbatch.html in the 'File Pattern' section.
# ps is a command used to show a user's processes.

#Use 'bash remove_slurm_files.sh' to delete the slurm files before moving onto the next example

ps
