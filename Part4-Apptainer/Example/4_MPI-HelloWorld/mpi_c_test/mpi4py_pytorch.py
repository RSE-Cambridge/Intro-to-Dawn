import os
import torch
import torch.nn as nn
from torch.nn.parallel import DistributedDataParallel as DDP
import intel_extension_for_pytorch
import torch.distributed as dist
from mpi4py import MPI

class Model(nn.Module):
    def __init__(self):
        super(Model, self).__init__()
        self.linear = nn.Linear(4, 5)

    def forward(self, input):
        return self.linear(input)


if __name__ == "__main__":

    torch.xpu.manual_seed(123)  # set a seed number
    
    size = MPI.COMM_WORLD.Get_size()
    rank = MPI.COMM_WORLD.Get_rank()
    name = MPI.Get_processor_name()

    os.environ['RANK'] = str(rank)
    os.environ['WORLD_SIZE'] = str(os.environ.get('WORLD_SIZE', 1))
    os.environ['MASTER_ADDR'] = str(os.environ.get('MASTER_ADDR','127.0.0.1') ) # your master address
    os.environ['MASTER_PORT'] = str(os.environ.get('MASTER_PORT','29500')  )    # your master port

    # Initialize the process group with ccl backend
    dist.init_process_group(backend='xccl')

    # For single-node distributed training, local_rank is the same as global rank
   # local_rank = dist.get_rank()
    local_rank = int(os.environ.get('OMPI_COMM_WORLD_RANK') or 0) 
    # Only set device for distributed training on GPU
    gpu_id = torch.distributed.get_rank() % torch.xpu.device_count()
    # local_rank=str(os.environ.get('OMPI_COMM_WORLD_LOCAL_RANK'),0  )
    torch.xpu.set_device(gpu_id) 
    device = "xpu:{}".format(local_rank) 
    #model = Model().to(device)
    #if dist.get_world_size() > 1:
    model = DDP(model, device_ids=[device])

    optimizer = torch.optim.SGD(model.parameters(), lr=0.001)
    loss_fn = nn.MSELoss().to(device)
    for i in range(3):
        print("Runing Iteration: {} on device {}".format(i, device))
        input = torch.randn(2, 4).to(device)
        labels = torch.randn(2, 5).to(device)
        # forward
        print("Runing forward: {} on device {}".format(i, device))
        res = model(input)
        # loss
        print("Runing loss: {} on device {}".format(i, device))
        L = loss_fn(res, labels)
        # backward
        print("Runing backward: {} on device {}".format(i, device))
        L.backward()
        # update
        print("Runing optim: {} on device {}".format(i, device))
        optimizer.step()         
