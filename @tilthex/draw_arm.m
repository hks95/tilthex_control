function rend = draw_arm(obj)
L0 = 0.078767;% vertical offset from the second motor to the base
L1 =  0.020728; % horizontal offset from the z axis to the second motor'
L2 = 0.107;
L3 = 0.300;
L4 = 0.320;
theta1 = obj.arm_state.theta1;
theta2 = obj.arm_state.theta2;
theta3 = obj.arm_state.theta3;

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

%% end point calculation
joint_orig = [0;0;0;1];
obj.arm_link_body.joint1 = A1_0*joint_orig;
obj.arm_link_body.joint2 = A1_0*A2_1*joint_orig;
obj.arm_link_body.joint3 = A1_0*A2_1*A3_2*joint_orig;
obj.arm_link_body.joint4 = A4_0*joint_orig;
obj.arm_link_body.joint5 = A6_0*joint_orig;
end

function A = transMat(a, alpha, d, theta)
A = [cos(theta), -sin(theta).*cos(alpha), sin(theta).*sin(alpha), a.*cos(theta);
    sin(theta), cos(theta).*cos(alpha), -cos(theta).*sin(alpha), a.*sin(theta);
    0, sin(alpha), cos(alpha), d;
    0, 0, 0, 1];
end