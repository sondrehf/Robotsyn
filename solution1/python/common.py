import numpy as np
import matplotlib.pyplot as plt

def rotate_x(radians):
    c = np.cos(radians)
    s = np.sin(radians)
    return np.array([[1, 0, 0, 0],
                     [0, c,-s, 0],
                     [0, s, c, 0],
                     [0, 0, 0, 1]])

def rotate_y(radians):
    c = np.cos(radians)
    s = np.sin(radians)
    return np.array([[ c, 0, s, 0],
                     [ 0, 1, 0, 0],
                     [-s, 0, c, 0],
                     [ 0, 0, 0, 1]])

def rotate_z(radians):
    c = np.cos(radians)
    s = np.sin(radians)
    return np.array([[c,-s, 0, 0],
                     [s, c, 0, 0],
                     [0, 0, 1, 0],
                     [0, 0, 0, 1]])

def translate(x, y, z):
    return np.array([[1, 0, 0, x],
                     [0, 1, 0, y],
                     [0, 0, 1, z],
                     [0, 0, 0, 1]])

def draw_frame(K, T, scale=1):
    uv0 = project(K, T@np.array([0,0,0,1]))
    uvx = project(K, T@np.array([scale,0,0,1]))
    uvy = project(K, T@np.array([0,scale,0,1]))
    uvz = project(K, T@np.array([0,0,scale,1]))
    plt.plot([uv0[0], uvx[0]], [uv0[1], uvx[1]], color='#cc4422')
    plt.plot([uv0[0], uvy[0]], [uv0[1], uvy[1]], color='#11ff33')
    plt.plot([uv0[0], uvz[0]], [uv0[1], uvz[1]], color='#3366ff')

def project(K, X):
    """
    X: A 4xn array of homogeneous camera coordinates
    K: Camera intrinsic matrix
    Result: 2xn array of pixel coordinates (u,v)
    """

    # This is in order to be able to apply the function on a single point
    # as well as an array of points. If X is a single point, it converts
    # it to a 2D array of size 4x1, rather than a 1D array of size 4.
    X = np.reshape(X, [4,-1])

    uvw = K@X[:3,:]
    uvw /= uvw[2,:]
    return uvw[:2,:]
