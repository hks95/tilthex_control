function [X,Y,Z] = arm_FK(theta1,theta2,theta3)
%% Arm properties (in mm)
L0 = 78.767;% vertical offset from the second motor to the base
L1 =  20.728; % horizontal offset from the z axis to the second motor'
L2 = 107;
L3 = 300;
L4 = 320;

%% Transformation matrices
A1_0 = transMat(-L1,90,L0,theta1);
A2_1 = transMat(L2,0,0,theta2);
A3_2 = transMat(L3,0,0,theta3 - theta2);
A4_3 = transMat(L2,0,0,180 - theta3 + theta2);

A4_1 = A12*A23*A34;
A4_0 = A01*A14;

A5_4 = transMat(L4,0,0,0);
A6_5 = transMat(0,0,0,-theta2);

A6_0 = A1_0*A4_1*A5_4*A6_5;

%% Reach calculation
r = [0, 0, 0, 1]';
rend = A6_0*r;

X = rend(1);
Y = rend(2);
Z = rend(3);


reach = sqrt(X^2 + Y^2 + Z^2);
fprintf('the maximum x,y,z are %f %f %f\n', X,Y,Z);
fprintf('the maximum reach is %f\n', reach);
end

function A = transMat(a, alpha, d, theta)
A = [cosd(theta), -sind(theta).*cosd(alpha), sind(theta).*sind(alpha), a.*cosd(theta);
    sind(theta), cosd(theta).*cosd(alpha), -cosd(theta).*sind(alpha), a.*sind(theta);
    0, sind(alpha), cosd(alpha), d;
    0, 0, 0, 1];
end


% from center to propeller tip : 480 mm
% current configuration max reach = 330 mm