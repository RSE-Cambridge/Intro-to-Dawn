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
#SBATCH --job-name="DL_R_3-build-sif" # create a short name for your job  
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --cpus-per-task=24          # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                # number of allocated gpus per node
#SBATCH --time=02:35:00             # Time assigned for the simulation
                                    #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn 
module load oneapi-level-zero/1.14/gcc/czctrcfw

unset APPTAINER_BIND
#
#
#
 PATH="${PATH}:/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/bin:/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/libfabric/bin"
export PATH

LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/lib:/usr/local/dawn/software/external/intel-#oneapi/2025.3/mpi/2021.17/opt/mpi/libfabric/lib"

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
export APPTAINER_NOCLEANUP=true

# --- run ------------------------------------------------------------

apptainer build --sandbox --fakeroot --fix-perms --rocm --bind "$(pwd -P)/Appt_folders/tmp":/tmp --bind "$(pwd -P)/Appt_folders/var/tmp":/var/tmp --bind "/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/bin":/mpi_bin1 --bind "/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/libfabric/bin":/mpi_bin2 --bind "/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/lib":/mpi_lib1 --bind "/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/opt/mpi/libfabric/lib":/mpi_lib2 "$(pwd -P)/DL_rocky_9-v3.0.sif" "$(pwd -P)/DL_rocky_9-v3.0.def"


