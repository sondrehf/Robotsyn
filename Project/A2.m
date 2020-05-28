clc; clear all; close all; 
data = load('data/HiCO.mat');
HICO_original = data.HICO_original;
HICO_noisy = data.HICO_noisy;
hico_wl = data.hico_wl;
seawater_Rs = data.seawater_Rs;
rho_d = load('data/deep_water_Rrs.txt');
rho_s = load('data/shallow_water_Rrs.txt');
valid_bands = load('data/valid_bands_Rrs.txt');

%% a)

RGB = createRGB(I);

k = 5; % Choose number of k-means classes
[L, C] = imsegkmeans(int16(HICO_original), k);
B = uint8(labeloverlay(RGB,L));
figure;
subplot(1,2,1);imshow(B);title("k-means cluster image k = 5");

xs = linspace(400, 1000, 100);
subplot(1,2,2);
for k=1:size(C,1)
    plot(xs, C(k,:))
    hold on;
    title('k-means cluster centers, k = 5')
    xlim([400, 1000])
    ylim([0, 50])
    xlabel('Wavelength [nm]');
    ylabel('Radiance [W/m^{-2}µm^{-1}sr^{-1}]')
end

%% Run this to perform several k-means and plot each result
[H, W, ~] = size(HICO_original);
L = zeros([H, W, k]);
B = zeros([H, W,3,k]);

% Perform k-means algorithm n times incrementally
for i=1:k
    L(:,:,i) = imsegkmeans(int16(HICO_original), i);
    B(:,:,:,i) = (labeloverlay(RGB,L(:,:,i)));
end 
B = uint8(B);

% Show images
for i=1:k
    if k < 4
        subplot(1,3,i), imshow(B(:,:,:,i));
        title(['k =  ', num2str(i)])
    elseif k < 7 
        subplot(2,3,i), imshow(B(:,:,:,i));
        title(['k = ', num2str(i)])
    elseif k < 10
        subplot(3,3,i), imshow(B(:,:,:,i));
        title(['k = ', num2str(i)])
    else 
        subplot(4,3,i), imshow(B(:,:,:,i));
        title(['k = ', num2str(i)])
    end
end 
%% Run for class distinguishing 

numberOfClasses = 10; % Choose how many classes

[H, W, ~] = size(HICO_original);

indexes = imsegkmeans(int16(HICO_original), numberOfClasses);

% Create all classes
classes = zeros([H, W,numberOfClasses ]);
for i=1:numberOfClasses
    classes(:,:,i) = reshape(indexes == i, H, W);
end 

figure;
for i=1:numberOfClasses
    if numberOfClasses < 4
        subplot(1,3,i), imshow(classes(:, :, i));
        title(['Class ', num2str(i)])
    elseif numberOfClasses < 7 
        subplot(2,3,i), imshow(classes(:, :, i));
        title(['Class ', num2str(i)])
    elseif numberOfClasses < 10
        subplot(3,3,i), imshow(classes(:, :, i));
        title(['Class ', num2str(i)])
    else 
        subplot(4,3,i), imshow(classes(:, :, i));
        title(['Class ', num2str(i)])
    end
end 

%% b)

% Initial values
a0 = 0.3272; a1 = -2.9940; 
a2 = 2.7218; a3 = 1.2259;
a4 = 0.5683;

a = [a1, a2, a3, a4]; 

% green = 28
% blue1 = 8, 16, 19
maxBlue = zeros([size(HICO_original,1), size(HICO_original,2)]);
% Choose max
for i=1:size(HICO_original,1)
    for j=1:size(HICO_original,2)
        maxBlue(i, j) = max(max(HICO_original(i,j,8), ...
            HICO_original(i,j,16)), HICO_original(i,j,19));
    end
end

% Perform OBPG algorithm 
lg_chlor = a0;
for i = 1:4 
    lg_chlor = lg_chlor + a(i).* ...
        (log10(maxBlue ./ HICO_original(:,:,28))).^i;
end 

chlor = 10.^lg_chlor;
chlor = chlor ./ max(chlor(:)); % Normalize
imshow(chlor);
title('Chlorophyll concentration (NASA OBPG)');


%% c)

% Create empty matrices
L_deep = zeros([1,length(rho_d)]);
L_shallow = zeros([1,length(rho_s)]);
A = zeros([2*length(rho_d), 2]);
a = zeros([1,length(rho_d)]);
b = zeros([1,length(rho_d)]);

% Estimate a and b
for i=1:length(rho_d)
    L_deep(i) = HICO_original(20,20,i);
    L_shallow(i) = HICO_original(70,100,i);
    
    A = [rho_d(i) 1; 
        rho_s(i) 1];
    
    y = [L_deep(i);
        L_shallow(i)];
    
    x = mldivide(A,y);
    a(i) = x(1);
    b(i) = x(2);
end 

L = HICO_original;

Rrs = zeros(size(HICO_original));

% Perform ELM for valid bands only
for i=1:length(valid_bands)
    if valid_bands(i) == 1
        Rrs(:,:,i) = (L(:,:,i)-b(i))/a(i);
    else 
        Rrs(:,:,i) = L(:,:,i);
    end
end 

% Create RGB image with atmosphere-corrected data
RGB = createRGB(Rrs);
imshow(RGB);
title('Atmospheric correction of RGB')

%% d)

a0 = 0.3272; a1 = -2.9940; 
a2 = 2.7218; a3 = 1.2259;
a4 = 0.5683;

a = [a1, a2, a3, a4]; 

% Find max blue
RrsBlue = zeros([size(Rrs,1), size(Rrs,2)]);
for i=1:size(Rrs,1)
    for j=1:size(Rrs,2)
        RrsBlue(i, j) = max(max(Rrs(i,j,8), ...
            Rrs(i,j,16)), Rrs(i,j,19));
    end
end

RrsGreen = Rrs(:,:,27);

% Perform OBPG
lg_chlor =  a0;
for i = 1:1:4
    lg_chlor = lg_chlor ... 
        + a(i)*(log10(RrsBlue./RrsGreen)).^i;
end
chlor = 10.^lg_chlor;
lg_chlor = lg_chlor ./ max(lg_chlor(:)); % Normalize
imshow(lg_chlor);
title('Chlorophyll concentration (NASA OBPG) with correction');

k = 5; % Choose number of k-means classes
[L, C] = imsegkmeans(int16(Rrs), k);

RGB = createRGB(Rrs);

B = uint8(labeloverlay(RGB,L));

figure;
subplot(1,2,1);
imshow(B);title("k-means k = 5 atmosphere corrected");
xs = linspace(400, 1000, 100);
subplot(1,2,2);
for k=1:size(C,1)
    plot(xs, C(k,:))
    hold on;
    title('k-means centers k = 5 atmosphere corrected')
    xlim([400, 1000])
    ylim([0, 50])
    xlabel('Wavelength [nm]');
    ylabel('Radiance [W/m^{-2}µm^{-1}sr^{-1}]')
end

%% Perform k-means incrementally (1, ..., k)
k = 5;
[H, W, ~] = size(Rrs);

L_d = zeros([H, W,k]);
B = zeros([H, W,3,k]);

% Perform k-means algorithm k times incrementally
for i=1:k
    L_d(:,:,i) = imsegkmeans(int16(Rrs), i);
    B(:,:,:,i) = (labeloverlay(RGB,L_d(:,:,i)));
end 
B = uint8(B);

% Show images
for i=1:k
    if k < 4
        subplot(1,3,i), imshow(B(:,:,:,i));
        title(['k =  ', num2str(i)])
    elseif k < 7 
        subplot(2,3,i), imshow(B(:,:,:,i));
        title(['k = ', num2str(i)])
    elseif k < 10
        subplot(3,3,i), imshow(B(:,:,:,i));
        title(['k = ', num2str(i)])
    else 
        subplot(4,3,i), imshow(B(:,:,:,i));
        title(['k = ', num2str(i)])
    end
end 

%% 
function RGB = createRGB(I)
    R = I(:,:,53);
    G = I(:,:,23);
    B = I(:,:,9); 
    RGB = cat(3, R, G, B);
    RGB = RGB ./ max(RGB(:)); % Normalize
end



