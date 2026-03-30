#!/bin/bash
# --- account ------------------------------------------------------
#SBATCH --account=<FIX_ME>      
#SBATCH --partition=pvc9    

# --- resources ------------------------------------------------------
#SBATCH --nodes=4                      # total number of nodes
#SBATCH --job-name="appt-mpi-hybrid-hello" # create a short name for your job  
#SBATCH --ntasks-per-node=1            # total number of tasks per node
#SBATCH --cpus-per-task=96             # cpu-cores per task (>1 if multi-threaded tasks) 
#SBATCH --gres=gpu:4                   # number of allocated gpus per node
#SBATCH --time=00:05:00                # Time assigned for the simulation
                                       #         days-hours:minutes:seconds 


# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn 
# module load oneapi-level-zero/1.14/gcc/czctrcfw

PATH="/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/bin:/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/libfabric/bin:${PATH}"
export PATH

LD_LIBRARY_PATH="/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/lib:/usr/local/dawn/software/external/intel-oneapi/2025.3/mpi/2021.17/opt/mpi/libfabric/lib:${LD_LIBRARY_PATH}"
# --- run ------------------------------------------------------------
mpirun -n $NP apptainer exec "$(pwd -P)/MPI-hybrid.sif" /opt/mpitest

 

 




