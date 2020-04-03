function [JTJ, JTr] = normal_equations(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll)
    r = residuals(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll);
    eps = 0.0001;
    J = [
        (residuals(K, platform_to_camera, p_model, uv, weights, yaw+eps, pitch, roll) - r)/eps ...
        (residuals(K, platform_to_camera, p_model, uv, weights, yaw, pitch+eps, roll) - r)/eps ...
        (residuals(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll+eps) - r)/eps
    ];
    JTJ = J'*J;
    JTr = J'*r;
end