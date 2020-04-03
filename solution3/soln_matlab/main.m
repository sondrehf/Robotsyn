clear;
K           = load('../data/cameraK.txt');
all_markers = load('../data/markers.txt');
XY          = load('../data/model.txt');
n           = size(XY,1);
for image_number=0:22
    I = imread(sprintf('../data/video%04d.jpg', image_number));
    markers = all_markers(image_number + 1,:)';
    markers = reshape(markers, [3, n])';
    matched = markers(:,1) == 1;
    uv = markers(matched, 2:3);

    % Convert pixel coordinates to normalized image coordinates
    xy = (uv - [K(1,3) K(2,3)]) ./ [K(1,1) K(2,2)];

    H = estimate_H(xy, XY(matched, 1:2));
    [T1,T2] = decompose_H(H);
    T = choose_solution(T1, T2);

    % Compute predicted corner locations using model and homography
    uv_pred = (K*H*XY')';
    uv_pred = uv_pred ./ uv_pred(:,3);

    clf();
    imshow(I, 'Interpolation', 'bilinear'); hold on;
    scatter(uv(:,1), uv(:,2), 'yellow', 'filled');
    scatter(uv_pred(:,1), uv_pred(:,2), 'red');
    draw_frame(K, T, 7);
    legend('Observed', 'Predicted');
    print(sprintf('../data/out%04d.png', image_number), '-dpng');
end

function H = estimate_H(xy, XY)
    n = size(XY, 1);
    A = zeros([n, 9]);
    for i=1:n
        X = XY(i,1); Y = XY(i,2);
        x = xy(i,1); y = xy(i,2);
        A(2*i + 0, :) = [X,Y,1, 0,0,0, -X*x, -Y*x, -x];
        A(2*i + 1, :) = [0,0,0, X,Y,1, -X*y, -Y*y, -y];
    end
    [U,S,V] = svd(A);
    h = V(:,9); % Solution ~ last column of V
    H = reshape(h, [3,3])';
    % Alternatively we can explicitly construct H:
    % H = [h(1) h(2) h(3) ;
    %      h(4) h(5) h(6) ;
    %      h(7) h(8) h(9) ];
end

function [T1,T2] = decompose_H(H)
    H = H / norm(H(:,1));
    r1 = H(:,1);
    r2 = H(:,2);
    r3 = cross(r1, r2); % note: r1 x r2 = -r1 x -r2 = r3
    t = H(:,3);
    R1 = [r1 r2 r3];
    R2 = [-r1 -r2 r3];
    T1 = [R1 t ; 0 0 0 1];
    T2 = [R2 -t ; 0 0 0 1];
end

function T = choose_solution(T1, T2)
    % n this case the plane origin is always in front of the
    % camera, so we can test the sign of the z-translation
    % component to choose the correct solution.
    if T1(3,4) > T2(3,4)
        T = T1;
    else
        T = T2;
    end
end
