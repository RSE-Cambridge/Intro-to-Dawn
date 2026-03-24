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

PROJECTROOT="$(pwd -P)"
export PROJECTROOT 
venv_name="mini-pyt27";
export venv_name;
NEW_ENV_PATH="$(pwd -P)/apps/envs/";
export LLM_ENV_PATH; 
FULL_P_VENV_NAME="${NEW_ENV_PATH}/${venv_name}";
export FULL_VENV_NAME;    
 
############################################## install miniconda
mkdir "${PROJECTROOT}/tmp"
cd "${PROJECTROOT}/tmp" 
conda_install_file="Miniconda3-py312_25.7.0-2-Linux-x86_64.sh"   
wget --no-verbose https://repo.anaconda.com/miniconda/${conda_install_file}
EXPECT_SHA256=188b5d94ab3acefdeaebd7cb470d2fb74a3280563c77075de6e3e1d58d84ab0a
echo "${EXPECT_SHA256}  ${conda_install_file}" | sha256sum --check 
bash  ${conda_install_file} -b -p "${PROJECTROOT}/apps"

rm -r ${conda_install_file} 
rm -rf "${PROJECTROOT}/tmp"
export PATH="${PROJECTROOT}/apps/bin":${PATH}
export LD_LIBRARY_PATH="${PROJECTROOT}/apps/lib":$LD_LIBRARY_PATH
export PYTHONPATH="${PROJECTROOT}/apps/bin":$PYTHONPATH 

export PIP_CACHE_DIR="/rds/user/${USER}/hpc-work/PIP_CACHE"
if [[ ! -e $PIP_CACHE_DIR ]]; then
    mkdir $PIP_CACHE_DIR
elif [[ ! -d $PIP_CACHE_DIR ]]; then
    echo "$PIP_CACHE_DIR already exists but is not a directory" 1>&2
fi
export CONDA_PKGS_DIRS="/rds/user/${USER}/hpc-work/CONDA_PKGS_DIRS"
 
if [[ ! -e $CONDA_PKGS_DIRS ]]; then
    mkdir $CONDA_PKGS_DIRS
elif [[ ! -d $CONDA_PKGS_DIRS ]]; then
    echo "$CONDA_PKGS_DIRS already exists but is not a directory" 1>&2
fi
######################### end of install miniconda #######################

cd "${PROJECTROOT}"
source "${PROJECTROOT}/bin/activate" base 
# not doing a conda init due to changes to .bashrc
conda create --yes --prefix="${FULL_P_VENV_NAME}"  python=3.12
export CONDA_ENVS_PATH="${FULL_P_VENV_NAME}:${CONDA_ENVS_PATH}"
conda init bash  
conda activate "${FULL_P_VENV_NAME}" 
python -m pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/xpu
python -m pip install intel-extension-for-pytorch==2.8.10+xpu oneccl_bind_pt==2.8.0+xpu --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/

python -c "import torch; import intel_extension_for_pytorch as ipex; print(torch.__version__); print(ipex.__version__); [print(f'[{i}]: {torch.xpu.get_device_properties(i)}') for i in range(torch.xpu.device_count())];"
 