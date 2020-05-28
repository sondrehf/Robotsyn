%% c)
clc; clear all; close all;
data = load('data/HiCO.mat');
HICO_original = data.HICO_original;

[H,W,L] = size(HICO_original);
I       = HICO_original;
X       = reshape(I, [H*W,L])';

% Create PCA with different P
[x_hat_pca, ~] = PCA(X, 1);
x_hat_pca = reshape(x_hat_pca, [H,W,L]);
[x_hat_pca2, ~] = PCA(X, 2);
x_hat_pca2 = reshape(x_hat_pca2, [H,W,L]);
[x_hat_pca3, ~] = PCA(X, 10);
x_hat_pca3 = reshape(x_hat_pca3, [H,W,L]);

RGB = createRGB(x_hat_pca);
RGB2 = createRGB(x_hat_pca2);
RGB3 = createRGB(x_hat_pca3);
RGB_orig = createRGB(HICO_original);
figure; 
subplot(2,2,1);imshow(RGB_orig);title('RGB of original image');
subplot(2,2,2);imshow(RGB);title('RGB PCA P = 1');
subplot(2,2,3);imshow(RGB2);title('RGB PCA P = 2');
subplot(2,2,4);imshow(RGB3);title('RGB PCA P = 10');

% Perform k-means 
k = 3;
L1 = imsegkmeans(int16(x_hat_pca2), k);
L3 = imsegkmeans(int16(HICO_original), k);
B1 = (labeloverlay(RGB,L1));
B2 = (labeloverlay(RGB_orig,L3));

figure;
subplot(1,2,1);imshow(B2);
title(sprintf('K-means (k = %d) of original image', k));
subplot(1,2,2);imshow(B1);
title(sprintf('K-means (k = %d) PCA, P = 2', k));


%% d)

clc; clear all; close all;

% Comment out which case
load('data/task_3_case_1.mat'); % Case 1
load('data/task_3_case_2.mat') ;% Case 2

[H,W,L]    = size(I_original);
X_original = reshape(I_original, [H*W,L])';
X          = reshape(I_noisy, [H*W,L])';
P          = 2;

X_hat_mnf      = MNF(X, P, Sigma_n);
[X_hat_pca, ~] = PCA(X, P);
X_hat_pca      = X_hat_pca';

error_mnf   = error(X_hat_mnf, X_original);
error_pca   = error(X_hat_pca, X_original);
error_noise = error(X, X_original);

subplot(221);
show_image(X_original, H,W,L);
title('Original');
subplot(222);
show_image(X, H,W,L);
title(sprintf('Noisy, error = %.1f%%', 100*error_noise))
subplot(223);
show_image(X_hat_mnf, H,W,L);
title(sprintf('MNF, error = %.1f%%, P = %d', 100*error_mnf, P));
subplot(224);
show_image(X_hat_pca, H,W,L);
title(sprintf('PCA, error = %.1f%%, P = %d', 100*error_pca, P));

%% e)

clc; clear all; close all;
data = load('data/HiCO.mat');
HICO_original = data.HICO_original;
HICO_noisy = data.HICO_noisy;

[H,W,L]  = size(HICO_noisy);
I        = HICO_noisy;
X        = reshape(I, [H*W,L]);

Xn = zeros([H*W, L]);
for i=1:H*W-1
    Xn(i,:) = X(i,:) - X(i+1,:);
end 
X = X';

Sigma_n    = cov(Xn);
X_original = reshape(HICO_original, [H*W,L])';

% Create error for table
X_hat_mnf1   = MNF(X, 1, Sigma_n);
X_hat_mnf3   = MNF(X, 3, Sigma_n);
X_hat_mnf5   = MNF(X, 5, Sigma_n);
X_hat_mnf10  = MNF(X, 10, Sigma_n);
X_hat_mnf30  = MNF(X, 30, Sigma_n);
X_hat_mnf50  = MNF(X, 50, Sigma_n);
X_hat_mnf100 = MNF(X, 100, Sigma_n);

error_mnf1   = error(X_hat_mnf1, X_original);
error_mnf3   = error(X_hat_mnf3, X_original);
error_mnf5   = error(X_hat_mnf5, X_original);
error_mnf10  = error(X_hat_mnf10, X_original);
error_mnf30  = error(X_hat_mnf30, X_original);
error_mnf50  = error(X_hat_mnf50, X_original);
error_mnf100 = error(X_hat_mnf100, X_original);

X_hat_pca1   = PCA(X, 1);
X_hat_pca3   = PCA(X, 3);
X_hat_pca5   = PCA(X, 5);
X_hat_pca10  = PCA(X, 10);
X_hat_pca30  = PCA(X, 30);
X_hat_pca50  = PCA(X, 50);
X_hat_pca100 = PCA(X, 100);

error_pca1   = error(X_hat_pca1', X_original);
error_pca3   = error(X_hat_pca3', X_original);
error_pca5   = error(X_hat_pca5', X_original);
error_pca10  = error(X_hat_pca10', X_original);
error_pca30  = error(X_hat_pca30', X_original);
error_pca50  = error(X_hat_pca50', X_original);
error_pca100 = error(X_hat_pca100', X_original);

RGB1 = createRGB(reshape(X_hat_mnf1', [H,W,L]));
RGB2 = createRGB(reshape(X_hat_mnf3', [H,W,L]));
RGB3 = createRGB(reshape(X_hat_mnf10', [H,W,L]));
RGB4 = createRGB(reshape(X_hat_mnf100', [H,W,L]));
RGB5 = createRGB(reshape(X_hat_pca1, [H,W,L]));
RGB6 = createRGB(reshape(X_hat_pca3, [H,W,L]));
RGB7 = createRGB(reshape(X_hat_pca10, [H,W,L]));
RGB8 = createRGB(reshape(X_hat_pca100, [H,W,L]));

subplot(2,4,1); imshow(RGB1); title('MNF P = 1');
subplot(2,4,2); imshow(RGB2); title('MNF P = 3');
subplot(2,4,3); imshow(RGB3); title('MNF P = 10');
subplot(2,4,4); imshow(RGB4); title('MNF P = 100');
subplot(2,4,5); imshow(RGB5); title('PCA P = 1');
subplot(2,4,6); imshow(RGB6); title('PCA P = 3');
subplot(2,4,7); imshow(RGB7); title('PCA P = 10');
subplot(2,4,8); imshow(RGB8); title('PCA P = 100');


%% Functions

function X_hat_mnf = MNF(X, P, Sigma_n)
    sigma      = cov(X');
    [u, s, ~] = eig(Sigma_n*inv(sigma));
    [~,ind] = sort(diag(s));
    Us = u(:,ind);
    Y = Us^(-1)*X; 
    X_hat_mnf = Us(:,1:P)*Y(1:P,:);     
end 

function RGB = createRGB(I)
    R = I(:,:,53);
    G = I(:,:,23);
    B = I(:,:,9); 
    RGB = cat(3, R, G, B);
    RGB = RGB ./ max(RGB(:)); % Normalize
end

function [X_hat_pca, e] = PCA(X, P)
    [~,N] = size(X);
    [coeff,score,~,~,e,mu1] = pca(X');
    X_hat_pca = score(:,1:P)*coeff(:,1:P)' + repmat(mu1,[N,1]);
end

function e = error(X, X_ref)
    e = mean(vecnorm(X - X_ref, 2, 1)) / mean(vecnorm(X_ref, 2, 1));
end

function show_image(X, H, W, L)
    imshow(reshape(X', [H,W,L]));
end