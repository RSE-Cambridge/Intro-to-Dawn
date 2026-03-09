#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9   
#SBATCH --mail-type=begin          # send email when job begins
#SBATCH --mail-type=end            # send email when job ends
#SBATCH --mail-user=FIX_THIS

# --- resources ------------------------------------------------------
#SBATCH --nodes=1                   # node count Normally set to 1 unless
                                    # you require multi-node, multi-GPU
#SBATCH --job-name="DL_R_3-run-sif" # create a short name for your job  
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --cpus-per-task=24          # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                # number of allocated gpus per node
#SBATCH --time=01:45:00             # Time assigned for the simulation
                                    #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn 
module load oneapi-level-zero/1.14/gcc/czctrcfw

unset APPTAINER_BIND 

PATH="/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/bin:/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/libfabric/bin:${PATH}"
export PATH

LD_LIBRARY_PATH="/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/lib:/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/opt/mpi/libfabric/lib:${LD_LIBRARY_PATH}"

export LD_LIBRARY_PATH
# clean cache older than 10 days to save space
apptainer cache clean --days 10 

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
 

# Exit at first failure.
set -e

CMD="apptainer run --writable-tmpfs --force pytorch2.8.sif"
echo "${CMD}"
eval ${CMD}


