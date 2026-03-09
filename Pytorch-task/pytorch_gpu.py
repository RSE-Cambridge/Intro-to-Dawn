# pytorch_gpu.py

"""PyTorch module."""
import torch; 
import intel_extension_for_pytorch as ipex; 
print(torch.__version__); 
print(ipex.__version__); 
[print(f'[{i}]: {torch.xpu.get_device_properties(i)}') for i in range(torch.xpu.device_count())];"
