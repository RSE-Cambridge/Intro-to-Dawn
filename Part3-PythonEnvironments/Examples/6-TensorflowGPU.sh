#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=FIX_THIS
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example1
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn
module load intelpython-conda
conda activate tensorflow-gpu

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example 6 - This example just shows the bare minimum of module loading for Tensorflow
#  It loads the module which has been provided by us for intelpython with conda
# in load the GPU enabled environment

echo "Testing GPU with Tensorflow"


echo "checking intel-extension-for-tensorflow installation:" 
echo "Verify the CPU setup:If a tensor is returned, you've installed TensorFlow successfully."
python3 -c "import tensorflow as tf; print(tf.reduce_sum(tf.random.normal([1000, 1000])))"
echo "Verify the GPU setup:If a list of GPU devices is returned, you've installed TensorFlow successfully."
python -c "import tensorflow as tf; xpus = tf.config.list_physical_devices(); print(xpus)"