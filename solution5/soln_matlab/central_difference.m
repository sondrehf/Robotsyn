function [Iu, Iv, Im] = central_difference(I)
    % Computes the gradient in the u and v direction using
    % a central difference filter, and returns the resulting
    % gradient images (Iu, Iv) and the gradient magnitude Im.
    g = [+1/2, 0, -1/2];
    Iu = zeros(size(I));
    Iv = zeros(size(I));
    for row=1:size(I,1)
        Iu(row,:) = conv(I(row,:), g, 'same');
    end
    for col=1:size(I,2)
        Iv(:,col) = conv(I(:,col), g, 'same');
    end
    Im = sqrt(Iu.^2 + Iv.^2);
end
