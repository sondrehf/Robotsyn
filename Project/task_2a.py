import tools
import spectral
import matplotlib.pyplot as plt
import numpy as np

HICO_original, HICO_noisy, hico_wl, seawater_Rs = tools.get_info('data/HICO.mat')

# kmeans(image, nclusters=10, max_iterations=20, **kwargs)
# m = class_map, MxN array, values are indices of the cluster for the corresponding element in image
# c = an n_clusters x B array of cluster centers

(m, c) = spectral.kmeans(HICO_original, 10, 30)

fig, (im, spectral_mes) = plt.subplots(ncols=2)
im.set_title('k-means clustering results')
im.imshow(m)

xs = np.linspace(0.400, 1.000, 100)

plt.title('k-means cluster centers')
for k in range(c.shape[0]):
    spectral_mes.plot(xs, c[k])
    plt.xlim(0.400, 1.000)

fig1 = plt.gcf()
plt.show()
plt.draw()
fig1.savefig('task_2a_k10_i30.png')
plt.clf()   # close the figure window
