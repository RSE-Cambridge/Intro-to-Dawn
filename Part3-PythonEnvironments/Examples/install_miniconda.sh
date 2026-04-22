#!/bin/bash

############################################## install miniconda
if [[ ! -e "${HOME}/bin/miniconda" ]]; then 
    mkdir "./tmp"
    cd "./tmp" 
    conda_install_file=$1   
    wget --no-verbose https://repo.anaconda.com/miniconda/${conda_install_file}
    EXPECT_SHA256=$2
    echo "${EXPECT_SHA256}  ${conda_install_file}" | sha256sum --check 
    bash  ${conda_install_file} -b -p "${HOME}/bin/miniconda"

    rm -r ${conda_install_file} 
    rm -rf "./tmp"
else
  echo "${HOME}/bin/miniconda"
  ls "${HOME}/bin/miniconda"
fi

echo "miniconda $1 installed in <${HOME}/bin/miniconda>"
######################### end of install miniconda #######################