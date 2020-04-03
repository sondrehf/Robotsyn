clc; clear all; 
%% Task 1b)

box = load('box.txt');
box = box'; 

K = [1000   0       320;
     0      1100    240;
     0      0       1];
 
p_cam = box + [0 0 6 0]';
uv = project(K, p_cam);

figure; clf;
axis equal;
grid on;
box on;
hold on;
scatter(uv(1,:), uv(2,:), '.');
xlim([0 640]);
ylim([0 480]);
xticks(linspace(0,640,5));
yticks(linspace(0,480,5));
set(gca, 'YDir', 'reverse'); % Make y-axis go from 0 at the top

%%
K = [1000   0       320;
     0      1100    240;
     0      0       1];
box = load('box.txt');
box = box'; 

T = translate(0, 0, 6)*rotate_x(deg2rad(30))*rotate_y(deg2rad(30));
p_cam = T*box;

uv = project(K, p_cam);
figure; clf;
axis equal;
grid on;
box on;
hold on;
scatter(uv(1,:), uv(2,:), '.');
xlim([0 640]);
ylim([0 480]);
xticks(linspace(0,640,5));
yticks(linspace(0,480,5));
draw_frame(K, box_to_camera, 1);

set(gca, 'YDir', 'reverse'); % Make y-axis go from 0 at the top

%%
clc; clear all;
heli_T = load('heli_pose.txt');

fx = 1075.47;
fy = 1077.22;
cx = 621.01;
cy = 362.80;

K = [fx     0     cx;
     0      fy    cy;
     0      0     1];
 
p1 = [0 0 0 1];
p2 = [0.1145 0 0 1]; 
p3 = [0 0.1145 0 1]; 
p4 = [0.1145 0.1145 0 1]; 
 
figure; 
im = imshow('quanser.jpg');
hold on; 
axis equal;
grid on;
box on;

basepoints = [p1; p2; p3; p4; p4/2+[0 0 0 0.5]]'; 
basepoints = heli_T*basepoints; 

uv = project(K, basepoints);

scatter(uv(1,:), uv(2,:), '.');
draw_frame(K, heli_T, 0.075);

%%
yaw = deg2rad(11.77); 
pitch = deg2rad(28.87); 
roll = deg2rad(-0.5); 

plat_cam = heli_T;
points = load('heli_points.txt'); 
points = points'; 

% Transformations 
base_plat = translate(0.1145/2, 0.1145/2, 0)*rotate_z(yaw); 
hinge_base = translate(0, 0, 0.325)*rotate_y(pitch);
arm_hinge = translate(0,0,-0.0552); 
rotors_arm = translate(0.653, 0, -0.0312)*rotate_x(roll); 

base_cam = plat_cam*base_plat; 
hinge_cam = base_cam*hinge_base; 
arm_cam = hinge_cam*arm_hinge; 
rotors_cam = arm_cam*rotors_arm;

uv = zeros([2, size(points, 2)]);
uv(:,1:3) = project(K, arm_cam*points(:,1:3)); 
uv(:,4:7) = project(K, rotors_cam*points(:,4:7)); 

figure; 
im = imshow('quanser.jpg');
hold on; 
axis equal;
grid on;
box on;

draw_frame(K, plat_cam, 0.075);
draw_frame(K, base_cam, 0.075);
draw_frame(K, hinge_cam, 0.075);
draw_frame(K, arm_cam, 0.075);
draw_frame(K, rotors_cam, 0.075);

scatter(uv(1,:), uv(2,:), 64, 'MarkerEdgeColor', 'black', 'MarkerFaceColor', 'yellow', 'LineWidth', 1.5);






