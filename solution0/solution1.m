clear;
rgb = imread('roomba.jpg');
width = size(rgb,2)
height = size(rgb,1)
rgb = im2double(rgb);

% Create a red image with pixel values (1, 0, 0)
target = zeros(height, width, 3);
target(:,:,1) = 1;

difference = rgb - target;
distance = vecnorm(difference, 2, 3); % Euclidean length (L2 norm) of the third dimension (rgb difference)
thresholded = distance < 0.7;         % Set pixels with length < 0.7 to 1 and others to 0

subplot(221); imshow(rgb);              title('RGB input');
subplot(222); imshow(rgb(:,:,1));       title('R channel');
subplot(223); imshow(rgb(:,:,1) > 0.6); title('Pixels with R > 0.6');
subplot(224); imshow(thresholded);      title('Pixels with ||rgb - [1 0 0]|| < 0.7');