% Dynamics of tilted hexarotor

function [x_dot,x_next ] = tilthex_dynamics(x, u, modelParams)
%DYNAMICS simulates the dynamics of the tilted hexarotor
%
%-----------input--------------
% dt       : scalar, time step
% u        : 6x1 vector, input of the system are rotor speeds
%

% Gravity acceleration

g = modelParams.g;
Kt = 2.98e-06; Kd = 0.0382;
dt = modelParams.dt;
% convert FRD to XYZ
R1 = [cosd(90) sind(90) 0; ...
     -sind(90) cosd(90) 0; ...
     0 0 1];
 
R2 = [cosd(180) 0 sind(180); ...
      0 1 0; ...
      -sind(180) 0 cosd(180)];
  
Rt = R1*R2;

% % Thrust for each rotor in body frame
% T1_rotor = [0;0;-Kt*input(1)^2];
% T1_body = obj.rotor1*T1_rotor;
% 
% T2_rotor = [0;0;-Kt*input(2)^2];
% T2_body = obj.rotor2*T2_rotor;
% 
% T3_rotor = [0;0;-Kt*input(3)^2];
% T3_body = obj.rotor3*T3_rotor;
% 
% T4_rotor = [0;0;-Kt*input(4)^2];
% T4_body = obj.rotor4*T4_rotor;
% 
% T5_rotor = [0;0;-Kt*input(5)^2];
% T5_body = obj.rotor5*T5_rotor;
% 
% T6_rotor = [0;0;-Kt*input(6)^2];
% T6_body = obj.rotor6*T6_rotor;
% 
% %total thrust
% Thrust = T1_body+T2_body+T3_body+T4_body+T5_body+T6_body;
% % Thrust = obj.mass*g*[0 0 -1]';
% 
% %total moment due to thrust
% M_thrust = cross(obj.link1_body,T1_body);
% M_thrust = M_thrust + cross(obj.link2_body,T2_body);
% M_thrust = M_thrust + cross(obj.link3_body,T3_body);
% M_thrust = M_thrust + cross(obj.link4_body,T4_body);
% M_thrust = M_thrust + cross(obj.link5_body,T5_body);
% M_thrust = M_thrust + cross(obj.link6_body,T6_body);
% 
% %reaction torque, opp to rotor spin direction, ccw +ve
% M_rxn= Kd*(-T1_body-T3_body-T5_body+T2_body+T4_body+T6_body);

% for now, ignore 
% moments due to rotor mass and legs
% drag
% gyroscopic effect

%ANDREW SAYS: CHECK INDEXING!!!
Thrust = u(1:3,1);
M_thrust = u(4:6,1);

x_dot = zeros(size(x,1), size(x,2));
x_next = zeros(size(x,1), size(x,2)+1);
x_next(:,1) = x(:,1); %set 1st entry to x
for i = 2:size(x_next,2)
    % just creating struct because the rest was written this way
    state.position = x_next(1:3,i-1);
    state.linear_vel = x_next(4:6,i-1);
    state.roll = x(7,i-1);
    state.pitch = x(8,i-1);
    state.yaw = x(9,i-1);
    state.angular_vel = x(10:12,i-1);

    state.R(1,1) = cos(state.yaw)*cos(state.pitch);
    state.R(1,2) = cos(state.yaw)*cos(state.pitch)*sin(state.roll) - sin(state.yaw)*cos(state.roll);
    state.R(1,3) = cos(state.yaw)*sin(state.pitch)*cos(state.roll) + sin(state.yaw)*sin(state.roll);
    state.R(2,1) = sin(state.yaw)*cos(state.pitch);
    state.R(2,2) = sin(state.yaw)*sin(state.pitch)*sin(state.roll) + cos(state.yaw)*cos(state.roll);
    state.R(2,3) = sin(state.yaw)*sin(state.pitch)*cos(state.roll) - cos(state.yaw)*sin(state.roll);
    state.R(3,1) = -sin(state.pitch);
    state.R(3,2) = cos(state.pitch)*sin(state.roll);
    state.R(3,3) = cos(state.pitch)*cos(state.roll);

    % Dynamics of the quadrotor
    dot_position     = state.linear_vel;
    dot_linear_vel   = g*[0 0 -1]' + 1/modelParams.m*state.R*(Thrust); %in world frame. Thrust must be negative!

    % eta_mat= [1 sin(Phi)*tan(The) cos(Phi)*tan(The);0 cos(Phi) - sin(Phi);0 sin(Phi)/cos(The) cos(Phi)/cos(The)];

    skew_angular_vel = [ 0 -state.angular_vel(3) state.angular_vel(2); state.angular_vel(3) 0 -state.angular_vel(1); -state.angular_vel(2) state.angular_vel(1) 0];
    dot_R            = state.R * skew_angular_vel;

    dot_attitude = [1 sin(state.roll)*tan(state.pitch) cos(state.roll)*tan(state.pitch); 0 cos(state.roll) -sin(state.roll); 0 sin(state.roll)/cos(state.pitch) cos(state.roll)/cos(state.pitch)] * state.angular_vel; 
    dot_angular_vel  = modelParams.inertia_tensor \ (-cross(state.angular_vel,modelParams.inertia_tensor*state.angular_vel)+M_thrust); 


    % Compute the state of the quadrotor at the next time step using forward
    % euler formula
    state.position   = state.position + dot_position*dt;
    state.linear_vel = state.linear_vel + dot_linear_vel*dt;
    state.linear_acc = dot_linear_vel;

    state.R = state.R + dot_R*dt;
    % Project the new rotation matrix to SO(3)
    % in order to get rid of the numerical error
    skew_angular_vel
%     dot_R
%     state.R
    [U, ~, V] = svd(state.R);
    state.R = U*V';

    state.angular_vel = state.angular_vel + dot_angular_vel*dt;
    state.angular_acc = dot_angular_vel;

    state.pitch = asin(-state.R(3, 1));
    state.yaw   = atan2(state.R(2, 1), state.R(1, 1));
    state.roll  = atan2(state.R(3, 2), state.R(3, 3));

       
    x_dot(:,i-1) = [dot_position; dot_linear_vel;dot_attitude ; dot_angular_vel];
    x_next(:,i) = [state.position; state.linear_vel; state.roll; state.pitch; state.yaw ;state.angular_vel ];
end
% fprintf('pos %f %f %f\n',state.position(1,1),state.position(2,1),state.position(3,1));
% fprintf('thrust %f %f %f\n',Thrust(1,1),Thrust(2,1),Thrust(3,1));
% fprintf('torque %f %f %f\n',M_thrust(1,1),M_thrust(2,1),M_thrust(3,1));
x_next = x_next(:,2:end); %remove the 1st column
end