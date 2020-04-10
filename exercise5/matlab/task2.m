clear;
edge_threshold = 0.02; % todo: choose an appropriate value
blur_sigma     = 1; % todo: choose an appropriate value
line_threshold = 10; % todo: choose an appropriate value
bins           = 500; % todo: choose an appropriate value
filename       = '../data/image1_und.jpg';

I_rgb       = imread(filename);
I_rgb       = im2double(I_rgb);
I_gray      = rgb2gray(I_rgb);
I_blur      = blur(I_gray, blur_sigma);
[Iu,Iv,Im]  = central_difference(I_blur);
[u,v,theta] = extract_edges(Iu, Iv, Im, edge_threshold);

%
% Task 2a: Compute accumulator array H
%
rho_max   = norm(size(I_rgb)); % Placeholder
rho_min   = -rho_max; % Placeholder
theta_min = -pi; % Placeholder
theta_max = pi; % Placeholder


rho = u.*cos(theta) + v.*sin(theta); 
[H, ~, ~] = histcounts2(theta, rho, bins, ...
    'XBinLimits', [theta_min, theta_max], ...
    'YBinLimits', [rho_min, rho_max]);
H = H'; % Make rows be rho and columns be theta

window_size = 11;
[peak_rows,peak_cols] = extract_peaks(H, window_size, line_threshold);

%
% Task 2c: Convert peak (row, column) pairs into (theta, rho) pairs.
%
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
