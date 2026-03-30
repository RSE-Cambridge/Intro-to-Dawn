#!/bin/bash -l
# --- account ------------------------------------------------------
#SBATCH --account=<FIX_ME>      
#SBATCH --partition=pvc9   

# --- resources ------------------------------------------------------
#SBATCH --nodes=1                   # node count Normally set to 1 unless
                                    # you require multi-node, multi-GPU
#SBATCH --job-name="Dawn-build-sif" # create a short name for your job  
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --cpus-per-task=24          # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                # number of allocated gpus per node
#SBATCH --time=00:45:00             # Time assigned for the simulation
                                    #         days-hours:minutes:seconds 


# Script for building Apptainer image from Docker image that has
# PyTorch installed with Intel extensions and GPU drivers.
# For information about the Docker image, see:
# https://hub.docker.com/r/intel/intel-extension-for-pytorch

# This script can be run interactively on a Dawn compute node or login node:
#     ./build_apptainer_image.sh
# or can be submitted to Dawn's Slurm batch system, substituting a
# valid project account for <project_account>:.
#     sbatch --acount=<project_account> ./build_apptainer_image.sh

T0=${SECONDS}
echo "Image build started on $(hostname): $(date)"
echo ""

# Exit at first failure.
set -e

CMD="apptainer build --force pytorch2.8.sif pytorch2.8.def"
echo "${CMD}"
eval ${CMD}

echo ""
echo "Image build completed on $(hostname): $(date)"
echo "Time for image build: $((${SECONDS}-${T0})) seconds"
