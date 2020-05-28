import numpy as np
from tools import *
import matplotlib.pyplot as plt
from scipy.io import loadmat

# ------------- TASK B -------------


def OBPG_algorithm(img, wl_list):
    a = np.array(([0.3272, -2.9940, 2.7218, -1.2259, -0.5683]))
    green = 555
    blue = [443, 490, 510]

    index_green = find_index(wl_list, green)
    index_blue = []
    for wavelgt in range(len(blue)):
        index_blue.append(find_index(wl_list, blue[wavelgt]))

    R_rs_b = np.array((img[:, :, index_blue[0]], img[:, :, index_blue[1]], img[:, :, index_blue[2]]))
    R_rs_g = np.array((img[:, :, index_green]))

    R_rs_b_max = np.empty_like(R_rs_g)
    for x in range(img.shape[0]):
        for y in range(img.shape[1]):
            R_rs_b_max[x][y] = max([img[x, y, blue] for blue in index_blue])

    summation = 0
    for i in range(1, len(a)):
        summation += a[i]*((np.log10(np.divide(R_rs_b_max, R_rs_g))) ** i)
    return a[0] + summation

if __name__ == '__main__':
    HICO_original, HICO_noisy, hico_wl, seawater_Rs = get_info('data/HICO.mat')
    chlor_cons = OBPG_algorithm(HICO_original, hico_wl)
    # chlor_cons_log = 10 ** chlor_cons
    cm = plt.imshow(chlor_cons)
    plt.axis('off')
    cbar = plt.colorbar(cm)
    cbar.ax.get_yaxis().labelpad = 20
    cbar.ax.set_ylabel(r'[$mg / m^3$]', rotation=270)
    plt.title('Concentration of chlorophyll-a log')

    fig1 = plt.gcf()
    plt.show()
    plt.draw()
    fig1.savefig('task_2b_OBPG.png')
    plt.clf()   # close the figure window
