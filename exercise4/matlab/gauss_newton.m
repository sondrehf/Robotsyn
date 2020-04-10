function [yaw, pitch, roll] = gauss_newton(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll)
    %
    % Task 1c: Implement the Gauss-Newton method
    %
    % This will involve calling the functions you defined in a and b.

    
    max_iter = 100;
    step_size = 0.25;
    for k=1:max_iter
        [JTJ, JTr] = normal_equations(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll);
        dx = JTJ \ -JTr; 
        yaw = yaw + step_size*dx(1);
        pitch = pitch + step_size*dx(2);
        roll = roll + step_size*dx(3);
       
    end
end

