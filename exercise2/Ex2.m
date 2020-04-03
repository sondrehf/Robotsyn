clc; clear all; close all; 
kitti = imread('data/kitti.jpg');
[height,width] = size(kitti, 1:2);

fx = 9.842439e+02;
cx = 6.900000e+02;
fy = 9.808141e+02;
cy = 2.331966e+02;
k1 = -3.728755e-01;
k2 = 2.037299e-01;
p1 = 2.219027e-03;
p2 = 1.383707e-03;
k3 = -7.233722e-02;

dst = zeros([height,width,3], 'uint8');

for v_dst=1:height
    for u_dst=1:width
        x = (u_dst - cx)/fx;
        y = (v_dst - cy)/fy;
        r2 = x*x + y*y;
        r4 = r2*r2;
        r6 = r4*r2;
        kr = k1*r2 + k2*r4 + k3*r6;
        dx = kr*x + 2*p1*x*y + p2*(r2 + 2*x*x);
        dy = kr*y + p1*(r2 + 2*y*y) + 2*p2*x*y;
        u_src = round(cx + fx*(x + dx));
        v_src = round(cy + fy*(y + dy));
        if u_src >= 1 && u_src <= width && v_src >= 1 && v_src <= height
            dst(v_dst, u_dst, :) = kitti(v_src, u_src, :);
        end
    end
end
imwrite(dst, 'kitti_und.jpg');
imshow(dst);
figure;
imshow(kitti);
