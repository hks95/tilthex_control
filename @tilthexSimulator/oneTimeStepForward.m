function [ ] = oneTimeStepForward( obj )
%ONETIMESTEPFORWARD forwards the simulation by one time step
%

% This is only a dummy observer currently. So the current state is set to
% be the true state read from the robot.
obj.curr_state.time_stamp  = obj.time;
obj.curr_state.position    = obj.robot.state.position;
obj.curr_state.linear_vel  = obj.robot.state.linear_vel;
obj.curr_state.linear_acc  = obj.robot.state.linear_acc;
obj.curr_state.R           = obj.robot.state.R;
obj.curr_state.angular_vel = obj.robot.state.angular_vel;
obj.curr_state.angular_acc = obj.robot.state.angular_acc;
obj.curr_state.yaw         = obj.robot.state.yaw;
obj.curr_state.pitch       = obj.robot.state.pitch;
obj.curr_state.roll        = obj.robot.state.roll;

%===================================================================
%                       Trajectory Planning
%===================================================================

% obj.traj_plan_timer = obj.traj_plan_timer + obj.time_step;
% if obj.traj_plan_timer > 1/obj.traj_plan_freq - 1e-10
% 
%     traj_plan_data = planner.evntData(obj.time, obj.curr_state);
%     notify(obj, 'trajPlanEvnt', traj_plan_data);
%     obj.traj_plan_timer = 0;
% 
% %     Set the entries of the desired state
%     obj.desired_state.time_stamp         = obj.time;
%     obj.desired_state.desired_yaw        = traj_plan_data.desired_yaw;
%     obj.desired_state.desired_position   = traj_plan_data.desired_position;
%     obj.desired_state.desired_linear_vel = traj_plan_data.desired_linear_vel;
%     obj.desired_state.desired_linear_acc = traj_plan_data.desired_linear_acc;
% 
% end

%===================================================================
%                           Control
%===================================================================

%-------------------- position controller---------------------------
obj.pos_control_timer = obj.pos_control_timer + obj.time_step;
if obj.pos_control_timer > 1/obj.pos_control_freq -1e-10

    pos_control_data = controller.posControlEvntData(obj.desired_state, obj.curr_state);
    notify(obj, 'posControlEvnt', pos_control_data);
    obj.pos_control_timer = 0;

    % Set the entries of the disired state
    obj.desired_state.time_stamp_from_pos_Controller = obj.time;
    obj.desired_state.desired_roll                   = pos_control_data.desired_roll;
    obj.desired_state.desired_pitch                  = pos_control_data.desired_pitch;

    % Set the entries of the control input
    obj.control_input.thrust_time_stamp = obj.time;
    obj.control_input.thrust            = pos_control_data.thrust;

end

%-------------------- Attitude controller---------------------------
obj.atti_control_timer = obj.atti_control_timer + obj.time_step;
if obj.atti_control_timer > 1/obj.atti_control_freq - 1e-10

    atti_control_data = controller.attiControlEvntData(obj.desired_state, obj.curr_state);
    notify(obj, 'attiControlEvnt', atti_control_data);
    obj.atti_control_timer = 0;

    % Set the entries of the control input
    obj.control_input.torque_time_stamp = obj.time;
    obj.control_input.torque            = atti_control_data.torque;

end

% Dynamics
% Compute the state of the tilhex at the next step
obj.robot.tilthex_dynamics(obj.time_step,obj.control_input);

% Visualization
obj.robot.drawTilthex();
% plot3(obj.desired_state.desired_position(1),obj.desired_state.desired_position(2),obj.desired_state.desired_position(3),'MarkerSize',10);

% Advance the time by time_step
obj.time = obj.time + obj.time_step;

end