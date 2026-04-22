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

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn 



# Visit https://github.com/RSE-Cambridge/Intro-to-Dawn for more information

# Example4 - This example just shows the downloading and using miniconda outside the module system

export PROJECTROOT="$(pwd -P)"  
export NEW_ENV_PATH="$(pwd -P)/.venv/";  
 
############################################## install miniconda
 
conda_install_file="Miniconda3-py312_25.7.0-2-Linux-x86_64.sh"    
EXPECT_SHA256=188b5d94ab3acefdeaebd7cb470d2fb74a3280563c77075de6e3e1d58d84ab0a

############################################## install miniconda end

export PATH="${PROJECTROOT}/apps/bin":${PATH}
export LD_LIBRARY_PATH="${PROJECTROOT}/apps/lib":$LD_LIBRARY_PATH
export PYTHONPATH="${PROJECTROOT}/apps/bin":$PYTHONPATH 

######################### end of install miniconda #######################

cd "${PROJECTROOT}"
source "${PROJECTROOT}/bin/activate" base 
conda create --yes --prefix="${FULL_P_VENV_NAME}"  python=3.12
export CONDA_ENVS_PATH="${FULL_P_VENV_NAME}:${CONDA_ENVS_PATH}"
# not doing a conda init due to changes to .bashrc
# conda init bash  
conda activate "${FULL_P_VENV_NAME}" 
python -m pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/xpu
python -m pip install intel-extension-for-pytorch==2.8.10+xpu oneccl_bind_pt==2.8.0+xpu --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/

python -c "import torch; import intel_extension_for_pytorch as ipex; print(torch.__version__); print(ipex.__version__); [print(f'[{i}]: {torch.xpu.get_device_properties(i)}') for i in range(torch.xpu.device_count())];"
 