#!/bin/bash


RDS_FOLDER="$(find ~/rds/ -maxdepth 1 -type l -name '*rds*' -print -quit)"
echo "using project folder for cache at ${RDS_FOLDER}" 

export PIP_CACHE_DIR="${RDS_FOLDER}/PIP_CACHE"
if [[ ! -e $PIP_CACHE_DIR ]]; then
    mkdir $PIP_CACHE_DIR
elif [[ ! -d $PIP_CACHE_DIR ]]; then
    echo "$PIP_CACHE_DIR already exists but is not a directory" 1>&2
fi
export CONDA_PKGS_DIRS="${RDS_FOLDER}/CONDA_PKGS_DIRS"
 
if [[ ! -e $CONDA_PKGS_DIRS ]]; then
    mkdir $CONDA_PKGS_DIRS
elif [[ ! -d $CONDA_PKGS_DIRS ]]; then
    echo "$CONDA_PKGS_DIRS already exists but is not a directory" 1>&2
fi