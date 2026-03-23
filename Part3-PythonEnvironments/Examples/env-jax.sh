#! /bin/bash

# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn      
module load intelpython-conda/2025.0  
conda activate pytorch-gpu-2.3.1 

# --- Work Dir ----------------------------------------------------
mkdir -p "/rds/user/${USER}/hpc-work/intel-jax-openxla-argonne-workload/jax_env"
cd "/rds/user/${USER}/hpc-work/intel-jax-openxla-argonne-workload"
export PROJECTROOT="$(pwd -P)" 
export FULL_VENV_NAME="$(pwd -P)/tf_env"

echo "EnvName ${FULL_VENV_NAME}"



# --- Cache Dirs for env ------------------------------------------
mkdir -p "/rds/user/${USER}/hpc-work/PIP_CACHE"
mkdir -p "/rds/user/${USER}/hpc-work/CONDA_PKGS_DIRS"     
export PIP_CACHE_DIR="/rds/user/${USER}/hpc-work/PIP_CACHE"
export CONDA_PKGS_DIRS="/rds/user/${USER}/hpc-work/CONDA_PKGS_DIRS"

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