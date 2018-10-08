% Dynamics of tilted hexarotor

function [ ] = dynamics( obj, dt, input )
%DYNAMICS simulates the dynamics of the quadrotor
%
%-----------input--------------
% dt       : scalar, time step
% u        : 4x1 vector, input of the system [thrust; 3d-torque]
%

% Gravity acceleration
g = 9.80665;

% Thrust and torque
thrust = input.thrust;
torque = input.torque;


% Dynamics of the quadrotor
dot_position     = obj.state.linear_vel;
dot_linear_vel   = g*[0 0 -1]' + obj.state.R*[0 0 thrust]'/obj.mass;
skew_angular_vel = [ 0 -obj.state.angular_vel(3) obj.state.angular_vel(2); obj.state.angular_vel(3) 0 -obj.state.angular_vel(1); -obj.state.angular_vel(2) obj.state.angular_vel(1) 0];
dot_R            = obj.state.R * skew_angular_vel;
dot_angular_vel  = obj.inertia_tensor \ (-skew_angular_vel*obj.inertia_tensor*obj.state.angular_vel + torque);


% Compute the state of the quadrotor at the next time step using forward
% euler formula
obj.state.position   = obj.state.position + dot_position*dt;
obj.state.linear_vel = obj.state.linear_vel + dot_linear_vel*dt;
obj.state.linear_acc = dot_linear_vel;

if abs(det(obj.state.R)-1) > 1e-5
    a = 1;
end
obj.state.R = obj.state.R + dot_R*dt;
% Project the new rotation matrix to SO(3)
% in order to get rid of the numerical error
[U, ~, V] = svd(obj.state.R);
obj.state.R = U*V';
obj.state.angular_vel = obj.state.angular_vel + dot_angular_vel*dt;
obj.state.angular_acc = dot_angular_vel;

obj.state.pitch = asin(-obj.state.R(3, 1));
obj.state.yaw   = atan2(obj.state.R(2, 1), obj.state.R(1, 1));
obj.state.roll  = atan2(obj.state.R(3, 2), obj.state.R(3, 3));


end