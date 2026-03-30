#!/bin/bash -l
# --- account ------------------------------------------------------
#SBATCH --account=<FIX_ME>      
#SBATCH --partition=pvc9   

# --- resources ------------------------------------------------------ 
#SBATCH --job-name="Ddp-sif" # create a short name for your job  
#SBATCH --nodes=2               # number of nodes
#SBATCH --gres=gpu:4            # number of allocated gpus per node
#SBATCH --time=01:00:00         # total run time limit (HH:MM:SS)

# Script for running example PyTorch model training on the Dawn
# supercomputer, using multi-node multi-GPU distributed data parallel
# with Apptainer containers.  The example is for training classification
# of hand-written digits from the MNIST dataset.
#
# This script can be run interactively on a Dawn compute node:
#     ./go_apptainer.sh
# or can be submitted to Dawn's Slurm batch system, substituting a
# valid project account for <project_account>:.
#     sbatch --acount=<project_account> ./go_apptainer.sh
#
# When working interactively, it's also possible to use this script to
# start a bash shell inside a container launched directly by Apptainer (no MPI):
#     ./go_apptainer.sh bash
# and to output the environment inside a container launched via
# MPI and Apptainer (the environment used for running the pytorch
# model training).  These options can be useful for debugging and
# environment checking.

T0=${SECONDS}
echo "Job start on $(hostname): $(date)"

# Exit at first failure.
set -e

# Set up environment for launching container.
source setup_apptainer.sh
APPTAINER_LAUNCH="apptainer exec pytorch2.8.sif"

# Ensure that data needed are downloaded before running application.
if [ ! -d data ]; then
    echo ""
    echo "Downloading dataset"
    T1=${SECONDS}
    DOWNLOAD_LAUNCH="python -c \"import torchvision as tv; tv.datasets.MNIST('data', download=True)\""
    CMD="${APPTAINER_LAUNCH} ${DOWNLOAD_LAUNCH}"
    echo "${CMD}"
    eval "${CMD}"
    echo "Time downloading dataset: $((${SECONDS}-${T1})) seconds"
fi

if [[ "bash" == "${1}" ]]; then
# Start bash shell inside a container launched directly by Apptainer (no MPI).
    CMD="${APPTAINER_LAUNCH} bash"
    echo ""
    echo "${CMD}"
    ${CMD}
    exit
elif [[ "env" == "${1}" ]]; then
# Output environment inside a container launched via MPI and Apptainer.
    CMD="mpiexec -n 1 ${APPTAINER_LAUNCH} env"
    echo ""
    echo "${CMD}"
    ${CMD}
    exit
fi

# Run and time application.
T2=${SECONDS}
PYTORCH_LAUNCH="\
python mnist_classify_ddp.py\
 --ntasks-per-node ${TASKS_PER_NODE}\
 --dist-url ${MASTER_ADDR}\
 --dist-port ${MASTER_PORT}\
 --cpus-per-task ${CPUS_PER_TASK}\
 --epochs 2\
"
CMD="${MPI_LAUNCH} ${APPTAINER_LAUNCH} ${PYTORCH_LAUNCH}"
echo ""
echo "PyTorch DDP run started: $(date)"
echo "${CMD}"
${CMD}
echo ""
echo "PyTorch DDP run completed: $(date)"
echo "Run time: $((${SECONDS}-${T2})) seconds"
echo ""
echo "Job time: $((${SECONDS}-${T0})) seconds"
