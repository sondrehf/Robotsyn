% Task 1a
function [Iu, Iv, Im] = central_difference(I)
    % Computes the gradient in the u and v direction using
    % a central difference filter, and returns the resulting
    % gradient images (Iu, Iv) and the gradient magnitude Im.
    
    kernel = [0.5, 0, -0.5]; 
    size(I,1)
    
    Iu = zeros(size(I)); % Placeholder
    Iv = zeros(size(I)); % Placeholder
    Im = zeros(size(I)); % Placeholder
    
    for row=1:size(I,1)
        Iu(row, :) = conv(I(row,:), kernel, 'same'); 
    end
    for col=1:size(I,2)
        Iv(:, col) = conv(I(:,col), kernel, 'same'); 
    end
    
    Im = sqrt(Iu.^2 + Iv.^2);
    

end
