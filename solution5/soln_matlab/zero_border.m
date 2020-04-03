function I = zero_border(I, b)
    [h,w] = size(I);
    I(1:b, :) = 0;
    I(h-b:h, :) = 0;
    I(:, 1:b) = 0;
    I(:, w-b:w) = 0;
end