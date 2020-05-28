import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat


def get_info(filepath):
    M = loadmat(filepath)
    HICO_original = M['HICO_original']  # Hyperspectral image cube
    HICO_noisy = M['HICO_noisy']  # HICO_original with added noise
    hico_wl = M['hico_wl']  # Physical wavelength corresponding to band i
    seawater_Rs = M['seawater_Rs']

    return HICO_original, HICO_noisy, hico_wl, seawater_Rs


def pseudo_RGB_img(hsi, wavelengths):
    print(find_index(wavelengths, 700), wavelengths[find_index(wavelengths, 700)])
    print(find_index(wavelengths, 530), wavelengths[find_index(wavelengths, 530)])
    print(find_index(wavelengths, 450), wavelengths[find_index(wavelengths, 450)])

    red = hsi[:, :, find_index(wavelengths, 700)]
    green = hsi[:, :, find_index(wavelengths, 530)]
    blue = hsi[:, :, find_index(wavelengths, 450)]

    rgb_array = np.zeros((hsi.shape[0], hsi.shape[1], 3), 'uint8')
    rgb_array[:, :, 0] = red
    rgb_array[:, :, 1] = green
    rgb_array[:, :, 2] = blue

    rgb_array = (rgb_array - np.min(rgb_array)) / np.ptp(rgb_array)
    return rgb_array


def find_index(wl_list, wl):
    diff_list = np.abs(wl_list - wl)
    return diff_list.argmin()