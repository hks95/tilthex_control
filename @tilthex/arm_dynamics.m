function [X,Y,Z] = arm_dynamics(obj)

%% base is not fixed, its the quad center
% Ax_y means A from x to y

% assuming both O0 and O1 move along with the quad. 
w0_0 = obj.state.angular_vel;
wdot0_0 = obj.state.angular_acc;
v0_0 = obj.state.linear_vel;
vdot0_0 = obj.state.linear_acc;
vdot_cm0_0 = vdot0_0;

%% arm params
L0 = obj.arm_state.L0;
L1 = obj.arm_state.L1;
L2 = obj.arm_state.L2;
L3 = obj.arm_state.L3;
L4 = obj.arm_state.L4;
theta1 = obj.arm_state.theta1;  %always 0 else might fail
theta2 = obj.arm_state.theta2;
theta3 = obj.arm_state.theta3;
theta1_dot = obj.arm_state.theta1_dot;
theta2_dot = obj.arm_state.theta2_dot;
theta3_dot = obj.arm_state.theta3_dot;
theta1_ddot = 0;
theta2_ddot = 0;
theta3_ddot = 0;
m1_1 = 0.1;
I1_1 = 0.01;


%% Transformation matrices
A1_0 = transMat(L1,-pi/2,L0,theta1);
A2_1 = transMat(L2,0,0,pi+theta2);
A3_2 = transMat(L3,0,0,theta3 - theta2);
A4_3 = transMat(L2,0,0,pi - theta3 + theta2);
A4_1 = A2_1*A3_2*A4_3;
A4_0 = A1_0*A4_1;
A5_4 = transMat(L4,0,0,0);
A6_5 = transMat(0,0,0,-theta2);
A6_0 = A1_0*A4_1*A5_4*A6_5;

%% Forward iteration
w1_1 = A1_0(1:3,1:3)\(w0_0) + [0;0;theta1_dot];
wdot1_1 = A1_0(1:3,1:3)\(wdot0_0) + cross(A1_0(1:3,1:3)\(w0_0),[0;0;theta1_dot]) + theta1_ddot;
vdot1_1 = A1_0(1:3,1:3)\(vdot0_0+cross(wdot0_0,[L1;0;L0]) + cross(w0_0,cross(w0_0,[L1;0;L0])));
vdot_cm1_1 = cross(wdot1_1,[-L1/2;L0/2;0]) + cross(w1_1,cross(w1_1,[-L1/2;L0/2;0])) + vdot1_1;
F1_1 = m1_1 * vdot_cm1_1;
N1_1 = I1_1*wdot1_1 + cross(wdot1_1,I1_1*w1_1);

% similarly do the rest later


% %% Reach calculation
% r = [0, 0, 0, 1]';
% rend = A6_0*r;
% 
% X = rend(1);
% Y = rend(2);
% Z = rend(3);
% 
% 
% reach = sqrt(X^2 + Y^2 + Z^2);
% fprintf('the maximum x,y,z are %f %f %f\n', X,Y,Z);
% fprintf('the maximum reach is %f\n', reach);
end

function A = transMat(a, alpha, d, theta)
A = [cos(theta), -sin(theta).*cos(alpha), sin(theta).*sin(alpha), a.*cos(theta);
    sin(theta), cos(theta).*cos(alpha), -cos(theta).*sin(alpha), a.*sin(theta);
    0, sin(alpha), cos(alpha), d;
    0, 0, 0, 1];
end
