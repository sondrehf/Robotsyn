clc; clear all; close all; 
data = load('data/HiCO.mat');
HICO_original = data.HICO_original;
HICO_noisy = data.HICO_noisy;
hico_wl = data.hico_wl;
seawater_Rs = data.seawater_Rs;

%% a)
n = length(hico_wl);
diff = zeros([1, n-1]);
for i=1:n-1
    diff(i) = hico_wl(i+1) - hico_wl(i);
end 

count = 0;
for i=1:length(diff)
    if round(diff(i),4) ~= round(mode(diff),4)
        count = count+1; 
    end
end

maxVal = max(diff);
minVal = min(diff);
fprintf('Most frequently occurring diff is: %.5f\n', ...
    mode(diff));
fprintf('There are %d cases where the value differ\n', count);
fprintf('Max diff is: %.5f\n', max(diff));
fprintf('Min diff is: %.5f\n\r', min(diff));

%% c)
% Cone cells in the human eye
% Red:   53 - [701.936]
% Green: 23 - [530.096]
% Blue:  9 -  [449.904]

R = HICO_original(:,:,53);
G = HICO_original(:,:,23);
B = HICO_original(:,:,9); 
RGB = cat(3, R, G, B);
RGB = RGB ./ max(RGB(:)); % Normalize
imshow(RGB)
title('RGB image');

%% d)
subplot(1,2,1);
imshow(RGB)
hold on;
plot(20,20,'cx'); hold on;
plot(100,70,'kx'); hold on;
plot(400,30, 'gx'); hold on;
legend('(20,20): Deep Water', ...
    '(100,70): Shallow Water', ...
    '(400, 30): Vegetation', 'Location', 'southeast');

deep = zeros([1, length(hico_wl)]);
shallow = zeros([1, length(hico_wl)]);
vegetation = zeros([1, length(hico_wl)]);
for n = 1 : length(hico_wl)
    base =  HICO_original(:,:,n);
    deep(n) = base(20, 20);
    shallow(n) = base(70, 100);
    vegetation(n) = base(30, 400);
end

subplot(1,2,2);
plot(hico_wl, deep, 'c-', 'LineWidth', 2);
hold on;
plot(hico_wl,shallow, 'k-', 'LineWidth', 2);
hold on;
plot(hico_wl,vegetation, 'g-', 'LineWidth', 2);
grid on;

legend('Deep Water', 'Shallow Water', 'Vegetation');
xlabel('Wavelength [nm]');
ylabel('Radiance [W/m^{-2}µm^{-1}sr^{-1}]')

