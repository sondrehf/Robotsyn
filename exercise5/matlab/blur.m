% Task 1b
function I_blur = blur(I, sigma)
    % Applies a 2-D Gaussian blur with standard deviation sigma to
    % a grayscale image I.
    h = ceil(3*sigma);
    x = linspace(-h, h, 2*h + 1);
    Gaussian = exp(-x.^2/(2*sigma^2))/sqrt(2*pi*sigma^2);    
    I_blur = zeros(size(I)); % Placeholder
    
    for row=1:size(I,1)
        I_blur(row, :) = conv(I(row,:), Gaussian, 'same'); 
    end
    for col=1:size(I,2)
        I_blur(:, col) = conv(I(:,col), Gaussian, 'same'); 
    end
end
