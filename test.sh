#!/bin/bash -l
# --- account ------------------------------------------------------
#SBATCH --account=support-gpu
#SBATCH --partition=pvc9
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --gres=gpu:1
#SBATCH --time=01:30:00
#SBATCH --job-name="TF-87-1n1gpu"
#SBATCH --reservation=new_image


module purge

module load rhel9/default-dawn;
module load intelpython-conda;
conda activate tensorflow-gpu
python -c "import tensorflow as tf; xpus = tf.config.list_physical_devices(); print(xpus)"



