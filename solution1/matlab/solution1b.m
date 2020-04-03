clear;
K = [1000 0 320 ; 
     0 1100 240 ; 
     0    0   1 ];
p_box = load('../box.txt');
p_box = p_box'; % Transpose to get 4xn array... easier to do matrix multiplication
p_cam = p_box + [0 0 6 0]';
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
