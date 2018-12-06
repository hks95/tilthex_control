%control.m implements the attitude control algorithm

function [  ] = control( obj, src, event_data )
%CONTROL is a attitude controller using PD 
%

% Desired attitude
desired_yaw   = event_data.desired_yaw;
desired_pitch = event_data.desired_pitch;
desired_roll  = event_data.desired_roll;


% Current attitude
R     = event_data.R;
pitch = asin(-R(3, 1));
yaw   = atan2(R(2, 1), R(1, 1));
roll  = atan2(R(3, 2), R(3, 3));


% Current angular velocity
angular_vel = event_data.angular_vel;


% Compute the error of attitude and anguler velocity
roll_err  = obj.shortestAngle(desired_roll,  roll);
pitch_err = obj.shortestAngle(desired_pitch, pitch);
yaw_err   = obj.shortestAngle(desired_yaw,   yaw);
er        = [roll_err, pitch_err, yaw_err]';
ew        = angular_vel;


% Compute the torque
torque    = obj.Kr*er + obj.Kw*ew;
% absTorque = min([obj.maxAbsTorque abs(torque)], [], 2);
% torque    = sign(torque).*absTorque;

% Filling the output
event_data.torque = torque;

end

