#!/bin/bash
# --- account ------------------------------------------------------
#SBATCH --account=<FIX_ME>      
#SBATCH --partition=pvc9    

# --- resources ------------------------------------------------------
#SBATCH --nodes=1                   # node count Normally set to 1 unless
                                    # you require multi-node, multi-GPU
#SBATCH --job-name="ApptEx-run-sif" # create a short name for your job  
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --cpus-per-task=24          # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:1                # number of allocated gpus per node
#SBATCH --time=01:45:00             # Time assigned for the simulation
                                    #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn  
unset APPTAINER_BIND  

echo "APPTAINER_CACHEDIR=${APPTAINER_CACHEDIR}"

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

CMD="apptainer run --writable-tmpfs HelloWorld-Py.sif"
echo "${CMD}"
eval ${CMD}


