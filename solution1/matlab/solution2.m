clear;
platform_to_camera = load('../heli_pose.txt');
points = load('../heli_points.txt');

K = [1075.47 0 621.01 ; 
     0 1077.22 362.80 ; 
     0       0      1 ];

yaw   = 11.77*pi/180;
pitch = 28.87*pi/180;
roll  = -0.5*pi/180;

% Helicopter coordinate frames
base_to_platform = translate(0.1145/2, 0.1145/2, 0.0)*rotate_z(yaw);
hinge_to_base    = translate(0, 0, 0.325)*rotate_y(pitch);
arm_to_hinge     = translate(0, 0, -0.0552);
rotors_to_arm    = translate(0.653, 0, -0.0312)*rotate_x(roll);
base_to_camera   = platform_to_camera*base_to_platform;
hinge_to_camera  = base_to_camera*hinge_to_base;
arm_to_camera    = hinge_to_camera*arm_to_hinge;
rotors_to_camera = arm_to_camera*rotors_to_arm;

% Project helicopter points
points = points'; % Transpose to do matrix multiply on each point
uv = zeros([2, size(points, 2)]);
uv(:,1:3) = project(K, arm_to_camera*points(:,1:3));
uv(:,4:7) = project(K, rotors_to_camera*points(:,4:7));

% Plot frames and helicopter points
I = imread('../quanser.jpg');
[height,width] = size(I,1:2);
imshow(I);
hold on;
draw_frame(K, platform_to_camera, 0.05);
draw_frame(K, base_to_camera, 0.05);
draw_frame(K, hinge_to_camera, 0.05);
draw_frame(K, arm_to_camera, 0.05);
draw_frame(K, rotors_to_camera, 0.05);
xlim([0, width]);
ylim([0, height]);
scatter(uv(1,:), uv(2,:), 64, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow', 'LineWidth', 1.5);
