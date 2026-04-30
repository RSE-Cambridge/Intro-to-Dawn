#!/bin/bash
# --- account ------------------------------------------------------ 
#SBATCH --account FIX_THIS 
#SBATCH --partition=pvc9 

# --- resources ------------------------------------------------------
#SBATCH --job-name=PytorchExample
#SBATCH --time=0-01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --output=cnn.out
#SBATCH --error=cnn.err

# IMPORTANT: do NOT use "set -e" before conda activate on this system
set -o pipefail

. /etc/profile.d/modules.sh
module purge
module load rhel9/default-dawn
module load intelpython-conda/2025.0

source "$(conda info --base)/etc/profile.d/conda.sh"

# conda activate may run "which fi_info" which returns nonzero -> would kill script under -e
conda activate pytorch-gpu-2.3.1

# Now it's safe to be strict
set -e

cd "$SLURM_SUBMIT_DIR"

echo "Host: $(hostname)"
echo "Time: $(date)"
echo "PWD : $(pwd)"
echo "Python: $(which python)"
python -V
python -c "import torch; print('xpu count', torch.xpu.device_count())"

# Run code
python pytorch_gpu.py