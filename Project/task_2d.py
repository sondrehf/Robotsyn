import numpy as np
import matplotlib.pyplot as plt
from tools import get_info
from task_2c import atmospheric_correction
from task_2b import OBPG_algorithm
import spectral

# ------------- TASK D -------------

deep_water_Rrs = np.loadtxt('data/deep_water_Rrs.txt')
shallow_water_Rrs = np.loadtxt('data/shallow_water_Rrs.txt')
valid_bands_Rrs = np.loadtxt('data/valid_bands_Rrs.txt')
HICO_original, HICO_noisy, hico_wl, seawater_Rs = get_info('data/HICO.mat')

HICO_corrected = atmospheric_correction(HICO_original, valid_bands_Rrs, deep_water_Rrs, shallow_water_Rrs)
cons_chlor_corr = OBPG_algorithm(HICO_corrected, hico_wl)
cons_chlor_org = OBPG_algorithm(HICO_original, hico_wl)
(m, c) = spectral.kmeans(HICO_corrected, 10, 30)

# fig, [[im, spec_mes], [cm_org, cm_corr]] = plt.subplots(nrows=2, ncols=2)
# fig, ax = plt.subplots(nrows=2, ncols=2, figsize=(10,10))
#
# ax[0, 0].imshow(m)
# ax[0, 0].set_title('k-means clustering results')
#
# xs = np.linspace(0.400, 1.000, 100)
# ax[0, 1].set_title('k-means cluster centers')
# for k in range(c.shape[0]):
#     ax[0, 1].plot(xs, c[k])
#     plt.xlim(0.400, 1.000)
#
# ax[1, 0].imshow(cons_chlor_org)
# ax[1, 0].axis('off')
# ax[1, 0].set_title('Concentration of chlorophyll-a')
#
# ax[1, 1].imshow(cons_chlor_corr)
# ax[1, 1].axis('off')
# ax[1, 1].set_title('Concentration of chlorophyll-a after correction')
#
# fig1 = plt.gcf()
# plt.show()
# plt.draw()
# fig1.savefig('task_2d_OBPG.png')
# plt.clf()   # close the figure window


fig1, [im, spec_mes] = plt.subplots(nrows=1, ncols=2)
im.imshow(m)
im.set_title('k-means clustering results')

xs = np.linspace(0.400, 1.000, 100)
spec_mes.set_title('k-means cluster centers')
for k in range(c.shape[0]):
    spec_mes.plot(xs, c[k])
    plt.xlim(0.400, 1.000)


fig2, [cm_org, cm_corr] = plt.subplots(nrows=1, ncols=2, figsize=(10,10))
cm_org.imshow(cons_chlor_org)
cm_org.axis('off')
cm_org.set_title('Concentration of chlorophyll-a')

cm_corr.imshow(cons_chlor_corr)
cm_corr.axis('off')
cm_corr.set_title('Concentration of chlorophyll-a after correction')

#fig1 = plt.gcf()
plt.show()
plt.draw()
fig1.savefig('task_2d_1.png')
fig2.savefig('task_2d_2.png')
plt.clf()   # close the figure window

