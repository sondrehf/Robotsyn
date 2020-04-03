function [yaw, pitch, roll] = gauss_newton(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll)
    max_iter = 100;    
    step_size = 0.25;
    for iter=1:max_iter
        [JTJ,JTr] = normal_equations(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll);
        step = JTJ \ -JTr;
        yaw = yaw + step_size*step(1);
        pitch = pitch + step_size*step(2);
        roll = roll + step_size*step(3);
    end
end