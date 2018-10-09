% Dynamics of tilted hexarotor

function [ ] = tilthex_dynamics( obj, dt, input)
%DYNAMICS simulates the dynamics of the tilted hexarotor
%
%-----------input--------------
% dt       : scalar, time step
% u        : 6x1 vector, input of the system are rotor speeds
%

% Gravity acceleration
g = 9.8;
Kt=2.98e-06; Kd=.0382;

% convert FRD to XYZ
R1 = [cosd(90) sind(90) 0;-sind(90) cosd(90) 0;0 0 1];
R2 = [cosd(180) 0 sind(180);0 1 0;-sind(180) 0 cosd(180)];
Rt = R1*R2;

% Thrust for each rotor in body frame
T1_rotor = [0;0;-Kt*input(1)^2];
T1_body = obj.rotor1*T1_rotor;

T2_rotor = [0;0;-Kt*input(2)^2];
T2_body = obj.rotor2*T2_rotor;

T3_rotor = [0;0;-Kt*input(3)^2];
T3_body = obj.rotor3*T3_rotor;

T4_rotor = [0;0;-Kt*input(4)^2];
T4_body = obj.rotor4*T4_rotor;

T5_rotor = [0;0;-Kt*input(5)^2];
T5_body = obj.rotor5*T5_rotor;

T6_rotor = [0;0;-Kt*input(6)^2];
T6_body = obj.rotor6*T6_rotor;

%total thrust
Thrust = T1_body+T2_body+T3_body+T4_body+T5_body+T6_body;
% Thrust = obj.mass*g*[0 0 -1]';

%total moment due to thrust
M_thrust = cross(obj.link1_body,T1_body);
M_thrust = M_thrust + cross(obj.link2_body,T2_body);
M_thrust = M_thrust + cross(obj.link3_body,T3_body);
M_thrust = M_thrust + cross(obj.link4_body,T4_body);
M_thrust = M_thrust + cross(obj.link5_body,T5_body);
M_thrust = M_thrust + cross(obj.link6_body,T6_body);

%reaction torque, opp to rotor spin direction, ccw +ve
M_rxn= Kd*(-T1_body-T3_body-T5_body+T2_body+T4_body+T6_body);

% for now, ignore 
% moments due to rotor mass and legs
% drag
% gyroscopic effect

% Dynamics of the quadrotor
dot_position     = obj.state.linear_vel;
dot_linear_vel   = g*[0 0 1]' + 1/obj.mass*obj.state.R*Thrust; %in world frame

% eta_mat= [1 sin(Phi)*tan(The) cos(Phi)*tan(The);0 cos(Phi) - sin(Phi);0 sin(Phi)/cos(The) cos(Phi)/cos(The)];

skew_angular_vel = [ 0 -obj.state.angular_vel(3) obj.state.angular_vel(2); obj.state.angular_vel(3) 0 -obj.state.angular_vel(1); -obj.state.angular_vel(2) obj.state.angular_vel(1) 0];
dot_R            = obj.state.R * skew_angular_vel;

dot_angular_vel  = obj.inertia_tensor \ (-cross(obj.state.angular_vel,obj.inertia_tensor*obj.state.angular_vel) + M_thrust + M_rxn);


% Compute the state of the quadrotor at the next time step using forward
% euler formula
obj.state.position   = obj.state.position + dot_position*dt;
obj.state.linear_vel = obj.state.linear_vel + dot_linear_vel*dt;

obj.state.R = obj.state.R + dot_R*dt;
% Project the new rotation matrix to SO(3)
% in order to get rid of the numerical error
[U, ~, V] = svd(obj.state.R);
obj.state.R = U*V';

obj.state.angular_vel = obj.state.angular_vel + dot_angular_vel*dt;

obj.state.pitch = asin(-obj.state.R(3, 1));
obj.state.yaw   = atan2(obj.state.R(2, 1), obj.state.R(1, 1));
obj.state.roll  = atan2(obj.state.R(3, 2), obj.state.R(3, 3));

fprintf('z pos %f thrust %f %f %f\n',obj.state.position(3,1),Thrust(1,1),Thrust(2,1),Thrust(3,1));
end