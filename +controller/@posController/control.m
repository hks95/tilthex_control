function [ ] = control( obj, src, event_data )
%CONTROL is a position controller
g = 9.8;

% Desired position, linear velocity and acceleration, and yaw angle
desired_position   = event_data.desired_position;
desired_linear_vel = event_data.desired_linear_vel;
desired_linear_acc = event_data.desired_linear_acc;
desired_yaw        = event_data.desired_yaw;


% Current postion, linear velocity and acceleration
position  = event_data.position;
linear_vel = event_data.linear_vel;
linear_acc = event_data.linear_acc;

% Compute the auxiliary control input
v = desired_linear_acc + obj.Kd*(desired_linear_vel-linear_vel) + obj.Kp*(desired_position-position);

F_arm = src.robot.arm_state.F;
R = src.robot.state.R;
% Compute the thrust
thrust    = obj.mass * R\(-g*[0 0 1]'+v) -1/obj.mass*R*F_arm;
absThrust = min(obj.max_thrust,norm(thrust));
thrust    = sign(thrust)*absThrust;


% Compute the command acceleration vector
% linear_acc_command = desired_linear_acc + obj.Kd*(desired_linear_vel-linear_vel) + obj.Kp*(desired_position-position);


% Compute the thrust
% thrust    = obj.mass * (g+linear_acc_command(3));

% Filling the output
event_data.desired_roll  = 0;
event_data.desired_pitch = 0;
event_data.thrust        = thrust;

end

