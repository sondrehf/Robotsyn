clc; clear all; close all;

load('data/task_3_case_1.mat'); % Case 1
%load('data/task_3_case_2.mat') ;% Case 2


PC = 100;
I = I_original;
%I = I_noisy;
RGB = PCA(I, 10);
% RGB2 = PCA(I, 15);
% RGB3 = PCA(I, 50);
% RGB4 = PCA(I, 100);
% [H,W,L]  = size(RGB);
% X_original = reshape(I_original, [H*W,L])';
% figure(4);
% subplot(1,4,1), imshow(RGB);
% title(sprintf('Original image P = %d, error = %.1f%%',...
%     5,100*error(reshape(RGB, [H*W,L])', X_original) ));
% 
% subplot(1,4,2), imshow(RGB2);
% title(sprintf('Original image P = %d, error = %.1f%%',...
%     15,100*error(reshape(RGB2, [H*W,L])', X_original) ));
% 
% subplot(1,4,3), imshow(RGB3);
% title(sprintf('Original image P = %d, error = %.1f%%',...
%     50,100*error(reshape(RGB3, [H*W,L])', X_original) ));
% 
% subplot(1,4,4), imshow(RGB4);
% title(sprintf('Original image P = %d, error = %.1f%%',...
%     100,100*error(reshape(RGB4, [H*W,L])', X_original) ));
% 
% 

[H,W,L]  = size(RGB);
X_hat_pca = reshape(RGB, [H*W,L])';
X = reshape(I_noisy, [H*W,L])';
X_original = reshape(I_original, [H*W,L])';
error_pca = error(X_hat_pca, X_original);
error_noise = error(X, X_original);

%% Maybe this?
clc; clear all; close all;

data = load('data/HiCO.mat');
HICO_original = data.HICO_original;

P = 10;

load('data/task_3_case_1.mat'); % Case 1
%I = I_original;
I = HICO_original;

[H,W,L]    = size(I);
X          = reshape(I, [H*W,L])';
sigma      = cov(X');

[coeff1,score1,~,~,~,mu1] = pca(X);
PC = score1(:,1:P)*coeff1(:,1:P)' + repmat(mu1,[L,1]);
%imshow(reshape(R', [H,W,L]));
PC = reshape(PC', [H,W,L]);
R = PC(:,:,53);
G = PC(:,:,23);
B = PC(:,:,9); 
RGB = cat(3, R, G, B);
RGB = RGB ./ max(RGB(:)); % Normalize
imshow(RGB); title('RGB image with P = 1')
figure;
L = imsegkmeans(int16(PC), 5);
B = (labeloverlay(RGB,L));
B = uint8(B);
imshow(B); title('K-means clustering with P = 1 and k = 5');


%%
figure(1);
subplot(1,2,1), imshow(I);
title(sprintf('Noisy image v2, error = %.1f%%',100*error_noise ));
subplot(1,2,2), imshow(RGB);
title(sprintf...
    ('PCA of noisy image v2, P = %d, error = %.1f%%', ...
    PC, 100*error_pca));

kmeans(I, RGB, 6, 10);

%% d

clc; clear all; close all;

load('data/task_3_case_1.mat'); % Case 1
%load('data/task_3_case_2.mat') ;% Case 2

PC = 2;
I = I_original;
[H,W,L]    = size(I);
X          = reshape(I, [H*W,L])';
sigma      = cov(X');

K = Sigma_n*inv(sigma); 
[u, s, v] = eig(K);

Y = u'*X; 

X_p = v(:,1:PC)*Y(1:PC,:); 
RGB = reshape(X_p, [200,200,3]);
RGB = RGB./max(RGB(:));


%%


function [M, A] = MNF(I, Sigma_n)
    [H,W,L]    = size(I);
    X          = reshape(I, [H*W,L])';
    sigma      = cov(X');
    [m, n] = size(X);
    [U1,S1,V1] = svd(Sigma_n'*Sigma_n);
    wX = X'*U1*inv(sqrt(S1));
    [U2,S2,V2] = svd(wX'*wX);
    A = U1*inv(sqrt(S1))*V2;
    M_new = X'*A;
    A = A';
    M = reshape(M_new, [200,200,3]);
end 

% function RGB = MNF(I,P, Sigma_n)
%     [H,W,L]    = size(I);
%     X          = reshape(I, [H*W,L])';
%     sigma      = cov(X');
%     size(X)
% 
%     A = Sigma_n*inv(sigma); 
%     [V, D, W] = eig(A);
% 
%     
%     Y = inv(W)*X; 
% 
%     X_p = W(:,1:P)*Y(1:P,:); 
%     RGB = reshape(X_p, [200,200,3]);
%     %RGB = K./max(K(:));
% end

% I is MxNx3 matrix RGB image
function RGB = PCA(I, P)  
    x1= I(:,:,1); x2= I(:,:,2); x3= I(:,:,3);
    [coeff1,score1,~,~,~,mu1] = pca(x1);
    [coeff2,score2,~,~,~,mu2] = pca(x2);
    [coeff3,score3,~,~,~,mu3] = pca(x3);
    R = score1(:,1:P)*coeff1(:,1:P)' + repmat(mu1,[length(coeff1),1]);
    G = score2(:,1:P)*coeff2(:,1:P)' + repmat(mu2,[length(coeff2),1]);
    B = score3(:,1:P)*coeff3(:,1:P)' + repmat(mu3,[length(coeff3),1]);
    RGB = cat(3, R, G, B);
    
    %maybe remove
    RGB = RGB ./ max(RGB(:));
end 

function [coeff, score, mu1] = calc_pca(X)
    covarianceMatrix = cov(X);
    [V,D] = eig(covarianceMatrix);
    
end 

function kmeans(RGB, I, k, P)
    L1 = imsegkmeans(int16(RGB), k);
    B1 = uint8((labeloverlay(RGB,L1)));
    L2 = imsegkmeans(int16(I), k);
    B2 = uint8(labeloverlay(I,L2));
    
    figure;
    subplot(1,2,1);imshow(B2);title(sprintf('K-means noisy image v2, k = %d', k));
    subplot(1,2,2);imshow(B1);title(sprintf('K-means PCA of noisy v2, k = %d, P = %d', k, P));

    [H, W, ~] = size(RGB);
    classes = zeros([H, W,k ]);
    for i=1:k
        classes(:,:,i) = reshape(L1 == i, H, W);
    end 

    figure;
    for i=1:k
        if k < 4
            subplot(1,3,i), imshow(classes(:, :, i));
            title(sprintf('PCA of noisy v2, class %d, P = %d', i, P));
        elseif k < 7 
            subplot(2,3,i), imshow(classes(:, :, i));
            title(sprintf('Class %d of original image', i));
            title(sprintf('Class %d of noisy v2', i));
            %title(sprintf('Class %d of PCA of noisy v2, P = %d', i, P));
        elseif k < 10
            subplot(3,3,i), imshow(classes(:, :, i));
            title(sprintf('PCA of original, class %d, P = %d', i, P));
        else 
            subplot(4,3,i), imshow(classes(:, :, i));
            title(sprintf('PCA of originale, class %d, P = %d', i, P));
        end
    end 
end 

function e = error(X, X_ref)
    e = mean(vecnorm(X - X_ref, 2, 1)) / mean(vecnorm(X_ref, 2, 1));
end

function show_image(X, H, W, L)
    imshow(reshape(X', [H,W,L]));
end
