# Script to enable MPI with Apptainer containers, using bind model:
# https://apptainer.org/docs/user/main/mpi.html#bind-model

# Set environment variables relating to MPI.
source setup_mpi.sh

# Define value for LD_LIBRARY_PATH to be used in container.
export APPTAINERENV_LD_LIBRARY_PATH="\
/usr/lib64/libibverbs:\
/usr/lib64:\
/.singularity.d/libs\
"

# Define host paths to be mapped to container paths, using bind mounts:
# https://apptainer.org/docs/user/main/bind_paths_and_mounts.html
export APPTAINER_BINDPATH="\
/etc/libibverbs.d,\
/usr/bin/ibv_devices,\
/usr/lib64/libefa.so.1,\
/usr/lib64/libibverbs,\
/usr/lib64/libibverbs.so.1,\
/usr/lib64/libmlx5.so.1,\
/usr/lib64/libmlx5.so.1.25.54.0,\
/usr/lib64/libnl-route-3.so.200,\
/usr/lib64/libnl-3.so.200,\
/usr/lib64/libnuma.so.1,\
/usr/lib64/libpsm2.so.2,\
/usr/lib64/librdmacm.so.1,\
/usr/lib64/libucm.so.0,\
/usr/lib64/libucp.so.0,\
/usr/lib64/libucs.so.0,\
/usr/lib64/libuct.so.0,\
/usr/local/dawn/software/spack-rocky9/opt-dawn-2025-03-23/linux-rocky9-sapphirerapids/oneapi-2025.1.0\
"
