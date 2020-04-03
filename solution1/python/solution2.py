import numpy as np
import matplotlib.pyplot as plt
from common import *

platform_to_camera = np.loadtxt('../heli_pose.txt')
points = np.loadtxt('../heli_points.txt')

K = np.array([[1075.47, 0, 621.01],
              [0, 1077.22, 362.80],
              [0,       0,      1]])

yaw   = 11.77*np.pi/180
pitch = 28.87*np.pi/180
roll  = -0.5*np.pi/180

# Helicopter coordinate frames
base_to_platform = translate(0.1145/2, 0.1145/2, 0.0)@rotate_z(yaw)
hinge_to_base    = translate(0, 0, 0.325)@rotate_y(pitch)
arm_to_hinge     = translate(0, 0, -0.0552)
rotors_to_arm    = translate(0.653, 0, -0.0312)@rotate_x(roll)
base_to_camera   = platform_to_camera@base_to_platform
hinge_to_camera  = base_to_camera@hinge_to_base
arm_to_camera    = hinge_to_camera@arm_to_hinge
rotors_to_camera = arm_to_camera@rotors_to_arm

# Project helicopter points
points = points.T # Transpose to do matrix multiply on each point
uv = np.zeros([2, points.shape[1]])
uv[:,:3] = project(K, arm_to_camera@points[:,:3])
uv[:,3:] = project(K, rotors_to_camera@points[:,3:])

# Plot frames and helicopter points
img = plt.imread('../quanser.jpg')
height,width = img.shape[0:2]
plt.imshow(img)
draw_frame(K, platform_to_camera, scale=0.05)
draw_frame(K, base_to_camera, scale=0.05)
draw_frame(K, hinge_to_camera, scale=0.03)
draw_frame(K, arm_to_camera, scale=0.04)
draw_frame(K, rotors_to_camera, scale=0.05)
plt.xlim([0, width])
plt.ylim([height, 0])
plt.scatter(uv[0,:], uv[1,:], color='yellow', edgecolors='black', linewidths=1)
plt.tight_layout()
plt.savefig('out.png')
