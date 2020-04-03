% Note: This script makes use of local functions (see bottom of file).
% https://se.mathworks.com/help/matlab/matlab_prog/local-functions-in-scripts.html

% Task c)
p1_a = [1 0 1]';
p2_b = [1 0 1]';
p3_b = [0.5 0.5 1]';
b_to_a = rotate(45);
a_to_b = b_to_a'; % Inverse of rotation matrix is its transpose
p1_b = a_to_b * p1_a % 0.707, -0.707
p2_a = b_to_a * p2_b % 0.707, 0.707
p3_a = b_to_a * p3_b % 0.000, 0.707

% Task e,f,g)
figure(1);
clf();

% Problem 1
T = rotate(30)*translate(3,0);
subplot(131);
hold on;
draw_frame(T, 'a');
grid(); 
box(); 
axis('equal');
xlim([-1 5]); 
ylim([-1 5]);
xticks([-1 0 1 2 3 4 5]);
yticks([-1 0 1 2 3 4 5]);
title('Problem 1');

% Problem 2
T = translate(2,1)*rotate(45);
subplot(132);
hold on;
draw_frame(T, 'a');
grid(); 
box(); 
axis('equal');
xlim([-1 5]); 
ylim([-1 5]);
xticks([-1 0 1 2 3 4 5]);
yticks([-1 0 1 2 3 4 5]);
title('Problem 2');

% Problem 3
T_a = rotate(30)*translate(1.5,0);
T_b = translate(0,3)*T_a*rotate(15);
T_c = rotate(-45)*T_b;
subplot(133);
hold on;
draw_frame(T_a, 'a');
draw_frame(T_b, 'b');
draw_frame(T_c, 'c');
grid(); 
box(); 
axis('equal');
xlim([-1 5]); ylim([-1 5]);
xticks([-1 0 1 2 3 4 5]);
yticks([-1 0 1 2 3 4 5]);
title('Problem 3');

%
% Function definitions
%
function T = rotate(degrees)
    c = cos(degrees*pi/180);
    s = sin(degrees*pi/180);
    T = [c -s 0 ; s c 0 ; 0 0 1];
end

function T = translate(x,y)
    T = [1 0 x ; 0 1 y ; 0 0 1];
end

function draw_line(a, b, color)
    plot([a(1) b(1)], [a(2) b(2)], 'linewidth', 2, 'color', color);
end

function draw_frame(T, label)
    origin = T*[0 0 1]';
    draw_line(origin, T*[1 0 1]', 'red');
    draw_line(origin, T*[0 1 1]', 'green');
    text(origin(1), origin(2) - 0.3, label);
end