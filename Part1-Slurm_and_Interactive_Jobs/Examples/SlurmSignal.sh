#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=<FIX_ACCOUNT> 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
# Slurm to send a signal to our script 120
# job name
#SBATCH --job-name=exampleSig 
#SBATCH --time=0-00:04:00 
#SBATCH --signal=B:USR1@120
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1

your_cleanup_function()
{
    echo "function your_cleanup_function called at $(date)"
    # do whatever cleanup you want here
}

# call your_cleanup_function once we receive USR1 signal
trap 'your_cleanup_function' USR1

echo "starting calculation at $(date)"

# the calculation "computes" (in this case sleeps) for 1000 seconds
# but we asked slurm only for 240 seconds so it will not finish
# the "&" after the compute step and "wait" are important
sleep 1000 &
wait