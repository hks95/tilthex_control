classdef (ConstructOnLoad) posControlEvntData < event.EventData

    properties

        %-----------inputs------------------
        % Desired attitude
        desired_position
        desired_linear_vel
        desired_linear_acc

        % Desired yaw angle
        desired_yaw

        % Current attitude and angular velocity
        position
        linear_vel
        linear_acc
        arm_F
        arm_M
        
        %-----------outputs-----------------
        % Output
        desired_roll
        desired_pitch
        thrust %3*1

    end

    methods


        function obj = posControlEvntData(desired_state, curr_state)
            
            obj.desired_position   = [2;2;2]; %desired_state.desired_position;
            obj.desired_linear_vel = [0;0;0]; 
            obj.desired_linear_acc = [0;0;0];

            obj.desired_yaw = 0; %desired_state.desired_yaw;

            obj.position   = curr_state.position;
            obj.linear_vel = curr_state.linear_vel;
            obj.linear_acc = curr_state.linear_acc;
            obj.arm_F = curr_state.arm_F;
            obj.arm_M = curr_state.arm_M;
        end


    end

end


