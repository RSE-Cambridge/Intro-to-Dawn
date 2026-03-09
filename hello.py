# hello.py

import time
import socket

node=socket.gethostname();
ts1=time.ctime()
print(f"hello from {node} at  {ts1}")
time.sleep(5)
ts2=time.ctime()
print(f"ByeBye from {node} at {ts2}")
