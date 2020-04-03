import numpy as np
import matplotlib.pyplot as plt
from common import *

K = np.array([[1000, 0, 320], [0, 1100, 240], [0, 0, 1]])
box_to_camera = translate(0,0,6)@rotate_x(0.5)@rotate_y(0.5)

p_box = np.loadtxt('../box.txt').T # Transpose to get 4xn array... easier to do matrix multiplication
uv = project(K, box_to_camera@p_box)

plt.scatter(uv[0,:], uv[1,:])
draw_frame(K, box_to_camera)
plt.grid()
plt.xlim([0, 640])
plt.ylim([480, 0])
plt.tight_layout()
plt.savefig('out.png')
