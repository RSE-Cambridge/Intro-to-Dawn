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
# Example5 - This example just shows the downloading and using UV outside the module system

# --- environment ----------------------------------------------------
module purge 
module load rhel9/default-dawn      

PYTHON_MAJOR_VERSION=3
PYTHON_MINOR_VERSION=9

# --- Work Dir ----------------------------------------------------

export PROJECTROOT="$(pwd -P)" 

UV_INSTALL_DIR="${PROJECTROOT}/venv/uv/bin"
UV_BIN="${UV_INSTALL_DIR}"
UV_CACHE_DIR="/rds/user/${USER}/hpc-work/.UV_CACHE_DIR"


DIR="${PROJECTROOT}/venv"
if [ -d "$DIR" ];
then
    echo "$DIR the apps directory exists."
else
	echo "$DIR apps directory does not exist."
    mkdir -p "$DIR"
fi
export FULL_VENV_NAME="${PROJECTROOT}/.venv"

DIR="${UV_BIN}"
if [ -d "$DIR" ];
then
    echo "$DIR venv/uv/bin directory exists."
else
	echo "$DIR venv/uv/bin directory does not exist."
    mkdir -p "$DIR"
fi 

DIR="${UV_CACHE_DIR}"
if [ -d "$DIR" ];
then
    echo "$DIR .UV_CACHE_DIR directory exists."
else
	echo "$DIR  .UV_CACHE_DIR directory does not exist."
   mkdir -p "$DIR"
fi 

echo "EnvName: ${FULL_VENV_NAME}"
echo "${FULL_VENV_NAME}" > envname.txt

while IFS= read -r line; do
    echo "Text read from file: $line"
done < envname.txt
 
 

mkdir "${PROJECTROOT}/venv/tmp"
cd "${PROJECTROOT}/venv/tmp"  
echo "In tmp Dir"
wget -qO- "https://github.com/astral-sh/uv/releases/download/0.9.17/uv-installer.sh"   | env UV_UNMANAGED_INSTALL=$UV_INSTALL_DIR sh

echo "finished dl installer for Uv"
 
# UV_PROJECT_ENVIRONMENT="${FULL_VENV_NAME}"
"${UV_BIN}/uv" version

echo "call ${UV_BIN}/uv  venv $FULL_VENV_NAME --python ${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}" 
"${UV_BIN}/uv" venv $FULL_VENV_NAME --python ${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}    
 
cd "${PROJECTROOT}"
rm -rf "${PROJECTROOT}/venv/tmp"
echo "in ${PROJECTROOT}/venv  dir" 
     
source  "${FULL_VENV_NAME}/bin/activate"    

echo "Source ${FULL_VENV_NAME}/bin/activate"
 
#"${UV_BIN}/uv" sync --active
# "${UV_BIN}/uv" sync --project . --extra cpu
# "${UV_BIN}/uv" sync --project . --extra rocm
"${UV_BIN}/uv" sync --project . --extra xpu

 