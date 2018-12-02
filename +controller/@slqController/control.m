function [ ] = control( obj, src, event_data )
%CONTROL is a position controller
g = 9.8;

% Filling the output
event_data.desired_roll  = 0;
event_data.desired_pitch = 0;
event_data.thrust        = thrust;
% fprintf('thrustx %f thrusty %f thrustz %f\n',thrust(1,1),thrust(2,1),thrust(3,1));
end

