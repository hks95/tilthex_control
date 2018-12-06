% Control mixer to distribute thurst and torques to 6 rotors

function [thrust,torque] = mixer(obj,control_input) 

 thrust_xyz = control_input.thrust;
 torque_pqr = control_input.torque;
 Kd=.0382;
 
T1 = sym('T1',[3 1]);
T2 = sym('T2',[3 1]);
T3 = sym('T3',[3 1]);
T4 = sym('T4',[3 1]);
T5 = sym('T5',[3 1]);
T6 = sym('T6',[3 1]);
 
% convert XYZ to FRD
R = [0 1 0;1 0 0;0 0 -1];

M_thrust = cross(R*obj.link1_body,T1);
M_thrust = M_thrust + cross(R*obj.link2_body,T2);
M_thrust = M_thrust + cross(R*obj.link3_body,T3);
M_thrust = M_thrust + cross(R*obj.link4_body,T4);
M_thrust = M_thrust + cross(R*obj.link5_body,T5);
M_thrust = M_thrust + cross(R*obj.link6_body,T6);

M_rxn = Kd*(-T1-T3-T5+T2+T4+T6);

eqn1 = T1 + T2 + T3 + T4 + T5 + T6 == thrust_xyz;
eqn2 = M_thrust + M_rxn == torque_pqr;

S = solve([eqn1 eqn2], [T1 T2 T3 T4 T5 T6]);

thrust = [S.T11+S.T21+S.T31+S.T41+S.T51+S.T61;
            S.T12+S.T22+S.T32+S.T42+S.T52+S.T62;
            S.T13+S.T23+S.T33+S.T43+S.T53+S.T63];
        
% similarly for torque
% too lazy, there is no motor controller, so feed directly for simplicity
end