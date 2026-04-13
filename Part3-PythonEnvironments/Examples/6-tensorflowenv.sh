#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=support-gpu
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example6-tensorflow
#SBATCH --time=0-00:55:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn

# --- Work Dir ----------------------------------------------------
NOW=$(date +%Y%m%d_%H%M%S) 
export PROJECTROOT="$(pwd -P)" 
echo "starting at <${NOW}> in:<${PROJECTROOT}>"
export PATH="${PROJECTROOT}/.tfvenv/bin":"${HOME}/bin/miniconda/bin":"$PATH"
# --- run ------------------------------------------------------------
export ENV_DIR="$(pwd -P)/.tfvenv"
if [[ ! -e $ENV_DIR ]]; then
    mkdir -p "$(pwd -P)/.tfvenv"
elif [[ ! -d $ENV_DIR ]]; then
    echo "$ENV_DIR already exists but is not a directory" 1>&2
fi

############################################## install miniconda
if [[ ! -e "${HOME}/bin/miniconda" ]]; then 
    mkdir "${PROJECTROOT}/tmp"
    cd "${PROJECTROOT}/tmp" 
    conda_install_file="Miniconda3-py311_26.1.1-1-Linux-x86_64.sh"   
    wget --no-verbose https://repo.anaconda.com/miniconda/${conda_install_file}
    EXPECT_SHA256=52d1f19154b0716d7dc0872f0d858702640da08a4e53fd0035ba988608203d6b
    echo "${EXPECT_SHA256}  ${conda_install_file}" | sha256sum --check 
    bash  ${conda_install_file} -b -p "${HOME}/bin/miniconda"

    rm -r ${conda_install_file} 
    rm -rf "${PROJECTROOT}/tmp"
fi

######################### end of install miniconda #######################
echo "miniconda installed in <${HOME}/bin/miniconda>"
cd "${PROJECTROOT}" 
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main
conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

source "/usr/local/dawn/software/external/intel-oneapi/2025.3.1/setvars.sh"
source "${HOME}/bin/miniconda/bin/activate" base
# which conda 
conda create --yes --prefix ".tfvenv"
ln -s  "${PROJECTROOT}/.tfvenv" "${HOME}/bin/miniconda/envs/.tfvenv"
conda activate ".tfvenv" 

which python 
python -m pip install --upgrade pip
echo "installing tensorflow and dependencies"
python -m pip install tensorflow
python -m pip install tensorflow_hub 
python -m pip install pillow
python -m pip install wget
echo "installing intel-extension-for-tensorflow[xpu]"
python -m pip install --upgrade intel-extension-for-tensorflow[xpu]
echo "checking intel-extension-for-tensorflow installation:"
python -c "import intel_extension_for_tensorflow as itex; print(itex.tools.python.env_check.check())"
python itex_test.py

export path_to_site_packages=`python -c "import site; print(site.getsitepackages()[0])"`
python "${path_to_site_packages}/intel_extension_for_tensorflow/tools/python/env_check.py"
