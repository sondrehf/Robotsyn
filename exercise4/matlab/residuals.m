function r = residuals(K, platform_to_camera, p_model, uv, weights, yaw, pitch, roll)
    base_to_platform = translate(0.1145/2, 0.1145/2, 0.0)*rotate_z(yaw);
    hinge_to_base    = translate(0, 0, 0.325)*rotate_y(pitch);
    arm_to_hinge     = translate(0, 0, -0.0552);
    rotors_to_arm    = translate(0.653, 0, -0.0312)*rotate_x(roll);
    base_to_camera   = platform_to_camera*base_to_platform;
    hinge_to_camera  = base_to_camera*hinge_to_base;
    arm_to_camera    = hinge_to_camera*arm_to_hinge;
    rotors_to_camera = arm_to_camera*rotors_to_arm;

    
    m = size(p_model,1); %m = 7
    m = cast(m,'uint8');
    p_cam = zeros([4, m]);
    p_cam(:,1:3) = arm_to_camera*p_model(1:3,:)';
    p_cam(:,4:7) = rotors_to_camera*p_model(4:7,:)';
    
    uv2 = K*p_cam(1:3,:);
    uv2 = uv2 ./ uv2(3,:);
    uv2 = uv2(1:2,:)';
     
    r = weights .* vecnorm(uv - uv2, 2, 2); 
end
