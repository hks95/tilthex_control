classdef (ConstructOnLoad) attiControlEvntData < event.EventData

    properties

        %-------------inputs------------------
        % Desired attitude
        desired_yaw
        desired_pitch
        desired_roll
%         desired_z

        % Current attitude and angular velocity
        R
        angular_vel
%         z

        %-------------outputs-----------------
        % Control inputs
%         thrust
        torque

    end

    methods

        function obj = attiControlEvntData( desired_state, curr_state )

            obj.desired_yaw   = 0;
            obj.desired_pitch = 0;
            obj.desired_roll  = 0;
%             obj.desired_z = 2;
            
            obj.R           = curr_state.R;
            obj.angular_vel = curr_state.angular_vel;
%             obj.z = curr_state.z;

        end


    end

end

