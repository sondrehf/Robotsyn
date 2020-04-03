clear;
edge_threshold = 0.02;
blur_sigma     = 1;
line_threshold = 10;
bins           = 500;
filename       = '../data/image1_und.jpg';

I_rgb       = imread(filename);
I_rgb       = im2double(I_rgb);
I_gray      = rgb2gray(I_rgb);
I_blur      = blur(I_gray, blur_sigma);
[Iu,Iv,Im]  = central_difference(I_blur);
[u,v,theta] = extract_edges(Iu, Iv, Im, edge_threshold);

rho_max   = norm(size(I_rgb));
rho_min   = -rho_max;
theta_min = -pi;
theta_max = +pi;

rho = u.*cos(theta) + v.*sin(theta);
[H, ~, ~] = histcounts2(theta, rho, bins, ...
    'XBinLimits', [theta_min, theta_max], ...
    'YBinLimits', [rho_min, rho_max]);
H = H';

window_size = 11;
[peak_rows,peak_cols] = extract_peaks(H, window_size, line_threshold);
peak_rho = rho_min + (rho_max - rho_min)*(peak_rows-0.5)/bins;
peak_theta = theta_min + (theta_max - theta_min)*(peak_cols-0.5)/bins;

subplot(211);
imagesc(H, 'XData', [theta_min theta_max], 'YData', [rho_min rho_max]);
xlabel('\theta (radians)');
ylabel('\rho (pixels)');
cb = colorbar();
cb.Label.String = 'Votes';
subplot(212);
imshow(I_rgb); hold on;
for i=1:size(peak_rho)
    draw_line(peak_theta(i), peak_rho(i));
end
