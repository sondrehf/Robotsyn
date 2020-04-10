function [pts_n, T] = normalize_points(pts)
    % Computes a normalizing transformation of the points such that
    % the points are centered at the origin and their mean distance from
    % the origin is equal to sqrt(2).
    %
    % See HZ, Ch. 4.4.4: Normalizing transformations (p107).
    %
    % Args:
    %     pts:    Input 2D point array of shape n x 2
    %
    % Returns:
    %     pts_n:  Normalized 2D point array of shape n x 2
    %     T:      The normalizing transformation in 3x3 matrix form, such
    %             that for a point (x,y), the normalized point (x',y') is
    %             found by multiplying T with the point:
    %
    %                 |x'|       |x|
    %                 |y'| = T * |y|
    %                 |1 |       |1|

    % todo: Compute pts_n and T
    
    
    % From Lecture 7 slide 47
    center = mean(pts);
    dist = mean(vecnorm(pts - center, 2, 2));
    scale = sqrt(2)/dist;
    pts_n = (pts - center)*scale;
    T = [scale 0     -center(1)*scale ; 
         0     scale -center(2)*scale ; 
         0     0          1      ];
end
