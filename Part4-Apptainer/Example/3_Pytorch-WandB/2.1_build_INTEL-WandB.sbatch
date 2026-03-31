#!/bin/bash
# --- account ------------------------------------------------------
#SBATCH --account=support-gpu      
#SBATCH --partition=pvc9  
  
# --- resources ------------------------------------------------------
#SBATCH --nodes=1                     # node count Normally set to 1 unless
                                      # you require multi-node, multi-GPU
#SBATCH --job-name="INTEL-WandB-sif"  # create a short name for your job  
#SBATCH --ntasks-per-node=1           # total number of tasks per node
#SBATCH --cpus-per-task=24            # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                  # number of allocated gpus per node
#SBATCH --time=00:55:00               # Time assigned for the simulation
                                      #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn

# clean cache older than 10 days to save space
yes y | apptainer cache clean --days 10 

echo "APPTAINER_CACHEDIR=${APPTAINER_CACHEDIR}"

# to avoid
#> INFO:    Creating SIF file...
#> FATAL:   While performing build: while creating squashfs: /usr/libexec/apptainer/bin/mksquashfs \
#> command failed: exit status 1: Write failed because No space left on device 
 
if [[ -z "${SLURM_JOBID}" ]]; then
   mkdir "/local/${RANDOM}"
   APPTAINER_TMPDIR="/local/${RANDOM}" 
else
   APPTAINER_TMPDIR="/local/${SLURM_JOBID}"
fi
echo "APPTAINER_TMPDIR=${APPTAINER_TMPDIR}"

export APPTAINER_TMPDIR;
mkdir "${APPTAINER_TMPDIR}"

# --- run ------------------------------------------------------------
T0=${SECONDS}
echo "Image build started on $(hostname): $(date)"
echo ""

# Exit at first failure.
set -e

CMD="apptainer build --force INTEL-WandB.sif INTEL-WandB.def"
echo "${CMD}"
eval ${CMD}

echo ""
echo "Image build completed on $(hostname): $(date)"
echo "Time for image build: $((${SECONDS}-${T0})) seconds"


