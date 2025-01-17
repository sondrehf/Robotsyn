import numpy as np
import matplotlib.pyplot as plt

# Task 1a
def central_difference(I):
    """
    Computes the gradient in the u and v direction using
    a central difference filter, and returns the resulting
    gradient images (Iu, Iv) and the gradient magnitude Im.
    """

    Iu = np.zeros_like(I)
    Iv = np.zeros_like(I)
    g = np.array([+1/2, 0, -1/2])
    for y in range(I.shape[0]): Iu[y,:] = np.convolve(I[y,:], g, mode='same')
    for x in range(I.shape[1]): Iv[:,x] = np.convolve(I[:,x], g, mode='same')
    Im = np.sqrt(Iu**2 + Iv**2)
    return Iu, Iv, Im

# Task 1b
def blur(I, sigma):
    """
    Applies a 2-D Gaussian blur with standard deviation sigma to
    a grayscale image I.
    """

    # Generate the 1-D Gaussian filter kernel
    h = int(np.ceil(3*sigma))
    x = np.linspace(-h, +h, 2*h + 1)
    g = np.exp(-x**2/(2*sigma**2))/np.sqrt(2*np.pi*sigma**2)

    # Filter the image (using the fact that the Gaussian is separable)
    Ig = np.zeros_like(I)
    for row in range(I.shape[0]): Ig[row,:] = np.convolve(I[row,:], g, mode='same')
    for col in range(I.shape[1]): Ig[:,col] = np.convolve(Ig[:,col], g, mode='same')
    return Ig

def zero_border(I, w):
    I[:w, :] = 0
    I[-w:, :] = 0
    I[:, :w] = 0
    I[:, -w:] = 0

# Task 1c
def extract_edges(Iu, Iv, Im, threshold):
    """
    Returns the u and v coordinates of pixels whose gradient
    magnitude is greater than the threshold. This does edge
    thinning using non-maximum suppression.
    """

    # To prevent accessing values outside the image we set
    # pixels near the border to zero.
    zero_border(Im, 10)

    # Find all edge candidates by thresholding the magnitude
    v, u = np.nonzero(Im > threshold)

    # Compute the pixel coordinate that is one step forward
    # and one step backward along the gradient direction.
    dir_u = Iu[v, u] / Im[v, u]
    dir_v = Iv[v, u] / Im[v, u]
    u_pos = np.rint(u + dir_u).astype(int)
    v_pos = np.rint(v + dir_v).astype(int)
    u_neg = np.rint(u - dir_u).astype(int)
    v_neg = np.rint(v - dir_v).astype(int)

    # Find the edges whose magnitude is greater than its neighbors
    # along the gradient direction.
    mask = Im[v, u] > Im[v_pos, u_pos]
    mask = np.logical_and(mask, Im[v, u] > Im[v_neg, u_neg])

    u = u[mask]
    v = v[mask]
    theta = np.arctan2(Iv[v,u], Iu[v,u])
    return u, v, theta

def rgb2gray(I):
    """
    Converts a red-green-blue (RGB) image to grayscale brightness.
    """
    return 0.2989*I[:,:,0] + 0.5870*I[:,:,1] + 0.1140*I[:,:,2]
