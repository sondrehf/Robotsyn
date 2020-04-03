import matplotlib.pyplot as plt
import numpy as np

src = plt.imread('data/kitti.jpg')
h,w = src.shape[0:2]

fx = 9.842439e+02
cx = 6.900000e+02
fy = 9.808141e+02
cy = 2.331966e+02
k1 = -3.728755e-01
k2 = 2.037299e-01
p1 = 2.219027e-03
p2 = 1.383707e-03
k3 = -7.233722e-02

fx_dst = fx
fy_dst = fy
cx_dst = cx
cy_dst = cy
w_dst = w
h_dst = h

dst = np.zeros([h_dst,w_dst,3], dtype='uint8')
for v_dst in range(h_dst):
    for u_dst in range(w_dst):
        x = (u_dst - cx_dst)/fx_dst
        y = (v_dst - cy_dst)/fy_dst
        x2 = x*x
        y2 = y*y
        r2 = x2 + y2
        r4 = r2*r2
        r6 = r4*r2
        kr = k1*r2 + k2*r4 + k3*r6
        dx = kr*x + 2*p1*x*y + p2*(r2 + 2*x2)
        dy = kr*y + p1*(r2 + 2*y2) + 2*p2*x*y
        u_src = int(cx + fx*(x + dx))
        v_src = int(cy + fy*(y + dy))
        if u_src >= 0 and u_src < w and v_src >= 0 and v_src < h:
            dst[v_dst,u_dst,:] = src[v_src,u_src,:]

plt.imsave('kitti_und.jpg', dst)

plt.figure(figsize=(5,4))
plt.subplot(211)
plt.imshow(src)
plt.subplot(212)
plt.imshow(dst)
plt.tight_layout()
plt.show()
