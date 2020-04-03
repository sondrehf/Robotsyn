function [yaw, pitch, roll] = levenberg_marquardt(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll)
    [JTJ, JTr] = normal_equations(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll);
    r = residuals(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll);
    prev_error = r'*r;
    lambda = 0.001*mean(diag(JTJ));
    max_iter = 10;
    xtol = 0.001;
    for iter=1:max_iter
        [JTJ, JTr] = normal_equations(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll);
        step = (JTJ + lambda*eye(3)) \ -JTr;
        next_yaw = yaw + step(1);
        next_pitch = pitch + step(2);
        next_roll = roll + step(3);
        r = residuals(K, platform_to_camera, p_model, uv, weights, next_yaw, next_pitch, next_roll);
        error = r'*r;
        if error < prev_error
            prev_error = error;
            yaw = next_yaw;
            pitch = next_pitch;
            roll = next_roll;
            lambda = lambda * 0.1;
            if norm(step) < xtol
                break
            end
        else
            lambda = lambda * 10;
        end
    end
end