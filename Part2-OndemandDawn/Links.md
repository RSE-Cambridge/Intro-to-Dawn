# Links for Ondemand
- Folder for Transcript [GoogleDocs Ondemand](https://drive.google.com/drive/folders/1HRwvaYS5iKuN6Hxgl5QKx-OS2lTc3CQ0)

- [Ondemand Site](https://login-web.hpc.cam.ac.uk/pun/sys/dashboard/)

- [Profile for AIRR Projects](https://access.hpc.cam.ac.uk/profile/)

- Show Account an QOS

```bash

sacctmgr show Association User=${USER}  "format=Account%20,qos"
 
mybalance

```

- Using pytorch ddp (DAWN workshop)[https://gitlab.developers.cam.ac.uk/kh296/dawn_workshop]

- Multinode bash function

```bash


function sintdawn9_multi()
{
    salloc --job-name=Multi-test --account=support-gpu --partition=pvc9 --nodes=2 --ntasks-per-node=4  --cpus-per-task=24  --gr>
    srun  --nodes=1 --cpus-per-task=24 --mem-per-cpu=3800 --export=USER,HOME,PATH,TERM  --pty /bin/bash -i
}

```