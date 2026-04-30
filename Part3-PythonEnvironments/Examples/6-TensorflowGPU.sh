#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=<FIX_ACCOUNT>
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example6_TF
#SBATCH --time=0-00:20:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn
module load intelpython-conda
conda activate tensorflow-gpu
TF_TEST="tf_testing.py"
# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example 6 - This example shows the bare minimum of module loading for Tensorflow
#  It loads the module which has been provided by us for IntelPython with conda
#  it then loads the GPU Tensorflow-enabled environment
cat <<EOF >>${TF_TEST}
# coding: utf-8
import tensorflow as tf;
import time
 

# To find out which devices your operations and tensors are assigned to
tf.debugging.set_log_device_placement(True)
 
print("Start CPU Test")
# Place tensors on the CPU
with tf.device('/CPU:0'):
  a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
  b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
  # Any additional tf code placed in this block will be executed on the CPU
  c = tf.matmul(a, b)
  print(c)
print("End CPU Test")

time.sleep(2)
print("Start GPU Test")
# Place tensors on the GPU
with tf.device('/XPU:0'):
  a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
  b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
  xpus = tf.config.list_physical_devices(); 
  print(xpus)
  c = tf.matmul(a, b) 
  print(c)
  print(xpus)
print("End GPU Test")
EOF
echo "Testing with Tensorflow"

python ${TF_TEST}