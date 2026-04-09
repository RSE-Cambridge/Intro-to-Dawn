#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account=<FIXME>
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example6-tensorflow
#SBATCH --time=0-00:45:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn
module load intelpython-conda/2025.0

# --- run ------------------------------------------------------------

export ENV_DIR="$(pwd -P)/apps/TensorFlowEnv"
if [[ ! -e $ENV_DIR ]]; then
    mkdir $ENV_DIR
elif [[ ! -d $ENV_DIR ]]; then
    echo "$ENV_DIR already exists but is not a directory" 1>&2
fi

export FULL_VENV_NAME="$(pwd -P)/apps/TensorFlowEnv"
conda info --envs
conda create --yes --prefix "${FULL_VENV_NAME}" --clone "/usr/local/dawn/software/external/intel-oneapi-ai/2025.0/intelpython"
conda activate "${FULL_VENV_NAME}"


cd "$(pwd -P)/apps/TensorFlowEnv/bin"

python -m pip install --upgrade pip
python -m pip install --user tensorflow==2.15.0
python -m pip install tensorflow_hub 
python -m pip install pillow
python -m pip install --upgrade intel-extension-for-tensorflow[xpu]

python -c "import intel_extension_for_tensorflow as itex; print(itex.tools.python.env_check.check())"
python itex_test.py

export path_to_site_packages=`python -c "import site; print(site.getsitepackages()[0])"`
python "${path_to_site_packages}/intel_extension_for_tensorflow/tools/python/env_check.py"
