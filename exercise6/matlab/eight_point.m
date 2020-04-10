function F = eight_point(uv1, uv2)
    % Given n >= 8 point matches, (u1 v1) <-> (u2 v2), compute the
    % fundamental matrix F that satisfies the equations
    %
    %     (u2 v2 1)^T * F * (u1 v1 1) = 0
    %
    % Args:
    %     uv1: (n x 2 array) Pixel coordinates in image 1.
    %     uv2: (n x 2 array) Pixel coordinates in image 2.
    %
    % Returns:
    %     F:   (3 x 3 matrix) Fundamental matrix mapping points in image 1
    %          to lines in image 2.
    %
    % See HZ Ch. 11.2: The normalized 8-point algorithm (p.281).

    % todo: Compute Fx
    [uv1_n, T1] = normalize_points(uv1);
    [uv2_n, T2] = normalize_points(uv2);
    n = size(uv1,1); 
    A = zeros([n, 9]);
    for i=1:n
        A(i, :) = [uv2_n(i,1)*uv1_n(i,1) uv2_n(i,1)*uv1_n(i,2) uv2_n(i,1) uv2_n(i,2)*uv1_n(i,1) uv2_n(i,2)*uv1_n(i,2) uv2_n(i,2) uv1_n(i,1) uv1_n(i,2) 1];
    end
    [~,~,V] = svd(A);
    f = V(:,9);
    F = reshape(f, [3,3])';
    %F = zeros([3,3]);
    F = closest_fundamental_matrix(F);
    F = T2'*F*T1;
end

%One finds least square solution (not unique) because rank is not exactly 8
function F = closest_fundamental_matrix(F)
    % Computes the closest fundamental matrix in the sense of the
    % Frobenius norm. See HZ, Ch. 11.1.1 (p.280).
    [U,S,V] = svd(F);
    F = U*diag([S(1,1), S(2,2), 0])*V';
    % todo: Compute closest matrix
end
