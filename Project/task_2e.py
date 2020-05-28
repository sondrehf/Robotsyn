from tools import *
import matplotlib.pyplot as plt
import numpy as np
import spectral
from task_2c import atmospheric_correction
from task_2b import OBPG_algorithm

# vegetation: [417, 137]
# ocean     : [20, 20]

HICO_original, HICO_noisy, hico_wl, seawater_Rs = get_info('data/HICO.mat')
land_mask = plt.imread('data/land_mask.png')[:, :, 0] == 0
deep_water_Rrs = np.loadtxt('data/deep_water_Rrs.txt')
shallow_water_Rrs = np.loadtxt('data/shallow_water_Rrs.txt')
valid_bands_Rrs = np.loadtxt('data/valid_bands_Rrs.txt')

(m, c) = spectral.kmeans(HICO_original, 6, 30)

I = pseudo_RGB_img(HICO_original, hico_wl)

land = np.empty_like(land_mask)
for i in range(m.shape[0]):
    for j in range(m.shape[1]):
        if m[i][j] != 0:
            land[i][j] = True
        else:
            land[i][j] = False

I[land] = 0
plt.imshow(I)

# Plot a RGB pseudo img
fig1 = plt.gcf()
plt.show()
plt.draw()
fig1.savefig('task_2e_mask_6.png')
plt.clf()   # close the figure window
