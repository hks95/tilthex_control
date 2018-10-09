function [ ] = oneTimeStepForward( obj,u )
%ONETIMESTEPFORWARD forwards the simulation by one time step
%

% Dynamics
% Compute the state of the tilhex at the next step
obj.robot.tilthex_dynamics(obj.time_step, u);

% Visualization
obj.robot.drawTilthex();

% Advance the time by time_step
obj.time = obj.time + obj.time_step;

end