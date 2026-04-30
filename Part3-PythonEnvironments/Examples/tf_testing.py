# coding: utf-8
import tensorflow as tf;
import time
 

# To find out which devices your operations and tensors are assigned to
tf.debugging.set_log_device_placement(True)
 
print("Start CPU Test")
# Place tensors on the CPU
with tf.device('/CPU:0'):
  a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
  b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
  # Any additional tf code placed in this block will be executed on the CPU
  c = tf.matmul(a, b)
  print(c)
print("End CPU Test")

time.sleep(2)
print("Start GPU Test")
# Place tensors on the GPU
with tf.device('/XPU:0'):
  a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
  b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
  xpus = tf.config.list_physical_devices(); 
  print(xpus)
  c = tf.matmul(a, b) 
  print(c)
  print(xpus)
print("End GPU Test")
