#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example5
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information
# Example jax environment - This example shows how to set up a jax environment using conda and pip outside the module system

# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn      
module load intelpython-conda/2025.0  
conda activate pytorch-gpu-2.3.1 

# --- Work Dir ----------------------------------------------------
RDS_FOLDER="$(find ~/rds/ -maxdepth 1 -type l -name '*rds*' -print -quit)"
mkdir -p "${RDS_FOLDER}/intel-jax-openxla/jax_env"
cd "${RDS_FOLDER}/intel-jax-openxla"
export PROJECTROOT="$(pwd -P)" 
export FULL_VENV_NAME="$(pwd -P)/tf_env"

echo "EnvName ${FULL_VENV_NAME}"



# --- Cache Dirs for env ------------------------------------------
mkdir -p "${RDS_FOLDER}/PIP_CACHE"
mkdir -p "${RDS_FOLDER}/CONDA_PKGS_DIRS"     
export PIP_CACHE_DIR="${RDS_FOLDER}/PIP_CACHE"
export CONDA_PKGS_DIRS="${RDS_FOLDER}/CONDA_PKGS_DIRS"

# --- Cache Dirs for env ------------------------------------------
conda info --envs
conda create --yes --prefix "${FULL_VENV_NAME}" --clone pytorch-gpu-2.3.1
conda activate "${FULL_VENV_NAME}" 
conda info --envs
echo "activated ${FULL_VENV_NAME}" 
 
TORCH_LIB=$(python -c "import torch; print(torch.__file__)" | sed 's/__init__.py/lib/')
TORCH_VERSION=`python -c "import torch; print(torch.__version__)" | sed 's/^\([0-9.]*\).*/\1/'`

export LD_LIBRARY_PATH=${TORCH_LIB}:$LD_LIBRARY_PATH 

pip install --upgrade intel-extension-for-tensorflow[xpu]
pip install --upgrade intel-extension-for-openxla
# Install jax, jaxlib and flax dependency
pip install -r https://raw.githubusercontent.com/intel/intel-extension-for-openxla/main/test/requirements.txt
python -c "import intel_extension_for_tensorflow as itex; print(itex.tools.python.env_check.check())"
python -c "import jax; print(jax.devices())"

cd "$PROJECTROOT/resnet50/"
git clone --branch=main https://github.com/google/flax
cd flax
git checkout ba9e24a7b697e6407465cb4b05a24a4cea152248
pip install -r examples/imagenet/requirements.txt
  
cd "$PROJECTROOT"
#https://github.com/intel/intel-extension-for-openxla/tree/main/example/resnet50