import matplotlib.pyplot as plt
import numpy as np
from common import draw_frame

def estimate_H(xy, XY):
    A = []
    n = XY.shape[0]
    for i in range(n):
        X,Y = XY[i]
        x,y = xy[i]
        A.append(np.array([X,Y,1, 0,0,0, -X*x, -Y*x, -x]))
        A.append(np.array([0,0,0, X,Y,1, -X*y, -Y*y, -y]))
    A = np.array(A)
    U,s,VT = np.linalg.svd(A)
    h = VT[8,:]
    H = np.reshape(h, [3,3])
    # Alternatively we can explicitly construct H
    # H = np.array([
    #     [h[0], h[1], h[2]],
    #     [h[3], h[4], h[5]],
    #     [h[6], h[7], h[8]]
    # ])
    return H

def decompose_H(H):
    H *= 1.0/np.linalg.norm(H[:,0])
    r1 = H[:,0]
    r2 = H[:,1]
    r3 = np.cross(r1, r2) # note: r1 x r2 = -r1 x -r2 = r3
    t  = H[:,2]
    R1 = np.array([r1, r2, r3]).T
    R2 = np.array([-r1, -r2, r3]).T
    T1 = np.eye(4)
    T2 = np.eye(4)
    T1[:3,:3] = R1
    T1[:3,3] = t
    T2[:3,:3] = R2
    T2[:3,3] = -t
    return T1, T2

def choose_solution(T1, T2):
    # In this case the plane origin should always be in front of the
    # camera, so we can test the sign of the z-translation component
    # to select the correct transformation.
    z1 = T1[2,3]
    z2 = T2[2,3]
    if z1 > z2:
        return T1
    else:
        return T2

K           = np.loadtxt('../data/cameraK.txt')
all_markers = np.loadtxt('../data/markers.txt')
XY          = np.loadtxt('../data/model.txt')
n           = len(XY)

for image_number in range(23):
    I = plt.imread('../data/video%04d.jpg' % image_number)
    markers = all_markers[image_number,:]
    markers = np.reshape(markers, [n, 3])
    matched = markers[:,0].astype(bool) # First column is 1 if marker was detected
    uv = markers[matched, 1:3] # Get markers for which matched = 1

    # Convert pixel coordinates to normalized image coordinates
    xy = (uv - K[0:2,2])/np.array([K[0,0], K[1,1]])

    H = estimate_H(xy, XY[matched, :2])
    T1,T2 = decompose_H(H)
    T = choose_solution(T1, T2)

    # Compute predicted corner locations using model and homography
    uv_hat = (K@H@XY.T)
    uv_hat = (uv_hat/uv_hat[2,:]).T

    plt.clf()
    plt.imshow(I, interpolation='bilinear')
    draw_frame(K, T, scale=7)
    plt.scatter(uv[:,0], uv[:,1], color='red', label='Observed')
    plt.scatter(uv_hat[:,0], uv_hat[:,1], marker='+', color='yellow', label='Predicted')
    plt.legend()
    plt.xlim([0, I.shape[1]])
    plt.ylim([I.shape[0], 0])
    plt.savefig('../data/out%04d.png' % image_number)
