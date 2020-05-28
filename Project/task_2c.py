# ------------- TASK C -------------
import numpy as np
from tools import *
import matplotlib.pyplot as plt
from PIL import Image


def atmospheric_correction(img, valid_bands, calibrated_rs_1, calibrated_rs_2):
    points = [(20, 20), (100, 70)]
    img_corrected = img.copy()

    for band in range(100):
        if valid_bands[band]:
            if band % 10 == 0:
                print("wopwop, now reached iteration", band)
            A = np.ones((2, 2))
            A[0, 0] = A[0, 0] * calibrated_rs_1[band]
            A[1, 0] = A[1, 0] * calibrated_rs_2[band]

            y = np.array([img[points[0]][band], img[points[1]][band]])
            a, b = np.linalg.solve(A, y)

            for x in range(img_corrected.shape[0]):
                for y in range(img_corrected.shape[1]):
                    img_corrected[x, y, band] = (img[x, y, band] - b) / a
    return img_corrected


if __name__ == '__main__':
    deep_water_Rrs = np.loadtxt('data/deep_water_Rrs.txt')
    shallow_water_Rrs = np.loadtxt('data/shallow_water_Rrs.txt')
    valid_bands_Rrs = np.loadtxt('data/valid_bands_Rrs.txt')
    HICO_original, HICO_noisy, hico_wl, seawater_Rs = get_info('data/HICO.mat')
    #hico_wl_valid = hico_wl[6:57]

    HICO_corrected = atmospheric_correction(HICO_original, valid_bands_Rrs, deep_water_Rrs, shallow_water_Rrs)
    print(HICO_corrected.shape)

    fig, (im_old, im_est) = plt.subplots(ncols=2)
    img_old = pseudo_RGB_img(HICO_original, hico_wl)
    img_est = pseudo_RGB_img(HICO_corrected, hico_wl)

    im_old.axis('off')
    im_est.axis('off')
    im_old.set_title('Image from original data')
    im_est.set_title('Image from corrected data')

    im_old.imshow(img_old)
    im_est.imshow(img_est)

    fig1 = plt.gcf()
    plt.show()
    plt.draw()
    fig1.savefig('task_2c.png')
    plt.clf()  # close the figure window
