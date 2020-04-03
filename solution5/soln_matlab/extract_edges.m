function [u, v, theta] = extract_edges(Iu, Iv, Im, threshold)
    % Returns the u and v coordinates of pixels whose gradient
    % magnitude is greater than the threshold. This does edge
    % thinning using non-maximum suppression.

    % To prevent accessing values outside the image we set
    % pixels near the border to zero.
    Im = zero_border(Im, 10);

    % Find all edge candidates by thresholding the magnitude
    [v,u] = find(Im > threshold);

    % Compute the pixel coordinate that is one step forward
    % and one step backward along the gradient direction.
    index = sub2ind(size(Im), v, u);
    du = Iu(index) ./ Im(index);
    dv = Iv(index) ./ Im(index);
    u_pos = round(u + du);
    u_neg = round(u - du);
    v_pos = round(v + dv);
    v_neg = round(v - dv);

    % Find the edges whose magnitude is greater than its neighbors
    % along the gradient direction.
    index_pos = sub2ind(size(Im), v_pos, u_pos);
    index_neg = sub2ind(size(Im), v_neg, u_neg);
    mask = and(Im(index) > Im(index_pos), Im(index) > Im(index_neg));

    u = u(mask);
    v = v(mask);
    theta = atan2(dv(mask), du(mask));
end
