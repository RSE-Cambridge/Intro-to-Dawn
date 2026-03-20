  #! /bin/bash  
      
      # --- account ------------------------------------------------------
      #SBATCH --account=<<FIXME>>     #  if you are a member of more than one Dawn project
      #SBATCH --partition=pvc9
      #SBATCH --qos=<<FIXME>>              # upon signing-up to Dawn you will be assigned a qos 
      
      # --- resources ------------------------------------------------------
      #SBATCH --nodes=1
      #SBATCH --ntasks-per-node=1 
      #SBATCH --cpus-per-task=24 
      #SBATCH --gres=gpu:1
      #SBATCH --time=01:00:00
      #SBATCH --job-name="CodeServer-1n1gpu" 
      set -eux # exit on error
      
      # --- environment ----------------------------------------------------
      module purge; 
      module load rhel9/default-dawn     
      
      CLI_PATH="${HOME}/vscode_cli"
      
      # Install the VS Code CLI command if it doesn't exist
      if [[ ! -e ${CLI_PATH}/code ]]; then
         echo "Downloading and installing the VS Code CLI command"
         mkdir -p "${HOME}/vscode_cli"
         pushd "${HOME}/vscode_cli"
         # Process from: https://code.visualstudio.com/docs/remote/tunnels#_using-the-code-cli
         curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz
         # unpack the code binary file
         tar -xf vscode_cli.tar.gz
         # clean-up
         rm vscode_cli.tar.gz
         popd
      fi
      
      # run the code tunnel command and accept the license
      ${CLI_PATH}/code tunnel --accept-server-license-terms