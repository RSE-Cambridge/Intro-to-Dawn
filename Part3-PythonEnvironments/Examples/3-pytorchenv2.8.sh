#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=example4
#SBATCH --time=0-00:10:00
#SBATCH --nodes=1                   # node count Normally set to 1
#SBATCH --ntasks-per-node=1         # total number of tasks per node
#SBATCH --gres=gpu:1                # number of allocated gpus per node

# --- environment ----------------------------------------------------
module purge
module load rhel9/default-dawn
module load intelpython-conda/2025.0

# --- run ------------------------------------------------------------

export ENV_DIR="$(pwd -P)/apps/pytorchEnv"
if [[ ! -e $ENV_DIR ]]; then
    mkdir $ENV_DIR
elif [[ ! -d $ENV_DIR ]]; then
    echo "$ENV_DIR already exists but is not a directory" 1>&2
fi

export FULL_VENV_NAME="$(pwd -P)/apps/pytorchEnv"
conda info --envs
conda create --yes --prefix "${FULL_VENV_NAME}" --clone "/usr/local/dawn/software/external/intel-oneapi-ai/2025.0/intelpython"
conda activate "${FULL_VENV_NAME}"
python -m pip install torch==2.8.0 torchvision==0.23.0 torchaudio==2.8.0 --index-url https://download.pytorch.org/whl/xpu
python -m pip install intel-extension-for-pytorch==2.8.10+xpu oneccl_bind_pt==2.8.0+xpu --extra-index-url https://pytorch-extension.intel.com/release-whl/stable/xpu/us/

cd "$(pwd -P)/apps/pytorchEnv/bin"
cp /usr/local/dawn/software/external/intel-oneapi-ai/2025.0/envs/pytorch-gpu-2.3.1/bin/torchrun .
cd "$(pwd -P)"

python -m pip install mpi4py
python -c "import torch; import intel_extension_for_pytorch as ipex; print(torch.__version__); print(ipex.__version__); [print(f'[{i}]: {torch.xpu.get_device_properties(i)}') for i in range(torch.xpu.device_count())];"

python ipex_test.py
