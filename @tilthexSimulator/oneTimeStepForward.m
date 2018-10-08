function [ ] = oneTimeStepForward( obj )
%ONETIMESTEPFORWARD forwards the simulation by one time step
%

%===================================================================
%                          Dynamics
%===================================================================


% Compute the state of the quadrotor at the next step
% obj.robot.dynamics(obj.time_step, obj.control_input);



%===================================================================
%                        Visualization
%===================================================================

% Draw the quadrotor
obj.robot.drawTilthex();

% % Show the captured image
% if ~isempty(obj.cam_measurement.time_stamp)
%     img = zeros(obj.robot.left_cam.img_size);
%     imshow(img, 'Parent', obj.image_axe_handle);
%     set(obj.image_axe_handle, 'NextPlot', 'add');
%     scatter(obj.image_axe_handle, obj.cam_measurement.left_cam.features(1, :), obj.cam_measurement.left_cam.features(2, :), 20, obj.feature_colors(:, obj.cam_measurement.left_cam.tags)', 'filled');
%     set(obj.image_axe_handle, 'NextPlot', 'replace');
% end


% Advance the time by time_step
obj.time = obj.time + obj.time_step;

end