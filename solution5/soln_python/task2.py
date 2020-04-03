import numpy as np
import matplotlib.pyplot as plt
from common1 import *
from common2 import *

edge_threshold = 0.02
blur_sigma     = 1
filename       = '../data/image1_und.jpg'
line_threshold = 10
bins           = 500

I_rgb      = plt.imread(filename)
I_rgb      = I_rgb/255.0
I_gray     = rgb2gray(I_rgb)
I_blur     = blur(I_gray, blur_sigma)
Iu, Iv, Im = central_difference(I_blur)
u,v,theta  = extract_edges(Iu, Iv, Im, edge_threshold)

rho_max   = +np.linalg.norm(I_rgb.shape)
rho_min   = -rho_max
theta_min = -np.pi
theta_max = +np.pi

rho = u*np.cos(theta) + v*np.sin(theta)
histrange = [[theta_min, theta_max], [rho_min, rho_max]]
H, _, _ = np.histogram2d(theta, rho, bins=bins, range=histrange)
H = H.T # Make rows be rho and columns be theta

peak_rows,peak_cols = extract_peaks(H, window_size=11, threshold=line_threshold)
peak_rho = rho_min + (rho_max - rho_min)*(peak_rows + 0.5)/bins
peak_theta = theta_min + (theta_max - theta_min)*(peak_cols + 0.5)/bins

plt.figure(figsize=[6,8])
plt.subplot(211)
plt.imshow(H, extent=[theta_min, theta_max, rho_min, rho_max], aspect='auto')
plt.xlabel('$\\theta$ (radians)')
plt.ylabel('$\\rho$ (pixels)')
plt.colorbar(label='Votes')
plt.title('Hough transform histogram')
plt.subplot(212)
plt.imshow(I_rgb)
plt.xlim([0, I_rgb.shape[1]])
plt.ylim([I_rgb.shape[0], 0])
for i in range(len(peak_theta)):
    draw_line(peak_theta[i], peak_rho[i], color='yellow')
plt.tight_layout()
plt.savefig('out2.png')
# plt.show()
