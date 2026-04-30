#!/usr/bin/env python
# coding: utf-8
# To find out which devices your operations and tensors are assigned to
tf.debugging.set_log_device_placement(True)
 
# Place tensors on the CPU
with tf.device('/CPU:0'):
  a = tf.constant([[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]])
  b = tf.constant([[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]])
  # Any additional tf code placed in this block will be executed on the CPU
  c = tf.matmul(a, b)
  print(c)

# ## Checking available devices
# 
# Since we want to leverage Intel's GPU for model training, here are simple instructions on how to check if the environment is setup.
# 
# In order to see which devices are available for TensorFlow to run its training on, 
# 
# NOTE: GPU will be displayed as `XPU` The line should look like:
# ```
# PhysicalDevice(name='/physical_device:XPU:0', device_type='XPU')
# ```

# In[ ]:


import tensorflow as tf

xpus = tf.config.list_physical_devices()
xpus 


print("[CODE_SAMPLE_COMPLETED_SUCCESSFULLY]")