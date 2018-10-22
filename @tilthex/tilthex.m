% tilt rotor hexacopter model

classdef tilthex < handle
    %class QUADROTOR simulates the behavior of a quadrotor
    %

    properties

        % axes handle, contains the plot of the quadrotor
        world_axes_handle

        % line handles, contains the for links of the quadrotor
        link1
        link2
        link3
        link4
        link5
        link6
        
        % 3-by-1 vectors, positions of the end points of the links in the body frame of the quad rotor
        link1_body
        link2_body
        link3_body
        link4_body
        link5_body
        link6_body
        
        % line handles, represent the body frame
        x_axis
        y_axis
        z_axis
        
        % 3-by-1 vectors, basis of the body frame
        x_axis_body
        y_axis_body
        z_axis_body
        
        %R matrix for each rotor
        rotor1
        rotor2
        rotor3
        rotor4
        rotor5
        rotor6
        
%         % z vector of the ith rotor frame
        z_rotor1_fig
        z_rotor2_fig
        z_rotor3_fig
        z_rotor4_fig
        z_rotor5_fig
        z_rotor6_fig
        
        z_axis_rotor1
        z_axis_rotor2
        z_axis_rotor3
        z_axis_rotor4
        z_axis_rotor5
        z_axis_rotor6
        
        
        % arm frames
        arm_link1
        arm_link2
        arm_link3
        arm_link4
        arm_link5
        
        arm_link_body
        
        % Mass and moment of inertia of the quad rotor
        mass
        inertia_tensor

        % struct, current state of the quadrotor
        %         including yaw pitch roll, angular
        %         velocity, angular acceleration,
        %         position, linear velocity and linear
        %         acceleration
        state
        
        arm_state

    end

    methods

        function obj = tilthex(world_axes_handle, hex_settings)

            % The axes where the quadrotor is drawn
            obj.world_axes_handle = world_axes_handle;

            % Colors for the front and back links
            color1 = [0 0 1];
            color2 = [0 1 0];
            % Create the links for the quadrotor
            obj.link1 = line('Parent',obj.world_axes_handle,'Color',color1,'Visible','off','LineWidth',3);
            obj.link2 = line('Parent',obj.world_axes_handle,'Color',color2,'Visible','off','LineWidth',3);
            obj.link3 = line('Parent',obj.world_axes_handle,'Color',color1,'Visible','off','LineWidth',3);
            obj.link4 = line('Parent',obj.world_axes_handle,'Color',color2,'Visible','off','LineWidth',3);
            obj.link5 = line('Parent',obj.world_axes_handle,'Color',color1,'Visible','off','LineWidth',3);
            obj.link6 = line('Parent',obj.world_axes_handle,'Color',color2,'Visible','off','LineWidth',3);
            
            % The vector for the links in the body frame
            link_len = hex_settings.link_len*cosd(15); %dihedral angle = 15
            link_z = hex_settings.link_len*sind(15);
            
            R = 1;
            
            % wrt to XYZ
            obj.link1_body = R*[ link_len*cosd(60),  link_len*sind(60),link_z ]';
            obj.link2_body = R*[link_len,0, link_z]';
            obj.link3_body = R*[link_len*cosd(60), -link_len*sind(60), link_z]';
            obj.link4_body = R*[-link_len*cosd(60), -link_len*sind(60), link_z]';
            obj.link5_body = R*[-link_len,0, link_z]';
            obj.link6_body = R*[-link_len*cosd(60), link_len*sind(60), link_z]';

            % Create the body frame, which is to be shown in the figure
            obj.x_axis = line('Parent',obj.world_axes_handle,'Color',[0 0 0],'Visible','off','LineWidth',2);
            obj.y_axis = line('Parent',obj.world_axes_handle,'Color',[0 0 0],'Visible','off','LineWidth',2);
            obj.z_axis = line('Parent',obj.world_axes_handle,'Color',[0 0 0],'Visible','off','LineWidth',2);

            obj.x_axis_body = [0 0.2 0]';
            obj.y_axis_body = [0.2 0 0]';
            obj.z_axis_body = [0 0 -0.2]';

            % Create the rotor frames, which is to be shown in the figure
            obj.rotor1 = hex_settings.rotor1;
            obj.rotor2 = hex_settings.rotor2;
            obj.rotor3 = hex_settings.rotor3;
            obj.rotor4 = hex_settings.rotor4;
            obj.rotor5 = hex_settings.rotor5;
            obj.rotor6 = hex_settings.rotor6;
            
            obj.z_rotor1_fig = line('Parent',obj.world_axes_handle,'Color',[1 0 1],'Visible','off','LineWidth',2);
            obj.z_rotor2_fig = line('Parent',obj.world_axes_handle,'Color',[1 0 1],'Visible','off','LineWidth',2);
            obj.z_rotor3_fig = line('Parent',obj.world_axes_handle,'Color',[1 0 1],'Visible','off','LineWidth',2);
            obj.z_rotor4_fig = line('Parent',obj.world_axes_handle,'Color',[1 0 1],'Visible','off','LineWidth',2);
            obj.z_rotor5_fig = line('Parent',obj.world_axes_handle,'Color',[1 0 1],'Visible','off','LineWidth',2);
            obj.z_rotor6_fig = line('Parent',obj.world_axes_handle,'Color',[1 0 1],'Visible','off','LineWidth',2);
            
            % wrt to rotor frame, while drawing coordinate transformations are done     
            obj.z_axis_rotor1 = [0 0 -0.3]';
            obj.z_axis_rotor2 = [0 0 -0.3]';
            obj.z_axis_rotor3 = [0 0 -0.3]';
            obj.z_axis_rotor4 = [0 0 -0.3]';
            obj.z_axis_rotor5 = [0 0 -0.3]';
            obj.z_axis_rotor6 = [0 0 -0.3]';
            
            % arm links
            obj.arm_link1 = line('Parent',obj.world_axes_handle,'Color',[0.7 0 0],'Visible','off','LineWidth',3);
            obj.arm_link2 = line('Parent',obj.world_axes_handle,'Color',[0.7 0 0],'Visible','off','LineWidth',3);
            obj.arm_link3 = line('Parent',obj.world_axes_handle,'Color',[0.7 0 0],'Visible','off','LineWidth',3);
            obj.arm_link4 = line('Parent',obj.world_axes_handle,'Color',[0.7 0 0],'Visible','off','LineWidth',3);
            obj.arm_link5 = line('Parent',obj.world_axes_handle,'Color',[0.7 0 0],'Visible','off','LineWidth',3);
                
            % arm end points
            
            % Set the mass the inertia tensor of the quadrotor
            obj.mass           = hex_settings.mass;
            obj.inertia_tensor = hex_settings.inertia_tensor;
                    
           % Initialize the orientation and position of the quadrotor in
            % the world
            obj.state = hex_settings.initial_state;            
            obj.arm_state = hex_settings.arm_initial_state;
            
            draw_arm(obj);
        end

        % Draw the quadrobot on the WORLD axes
        [ ] = drawTilthex( obj )

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % @brief: Compute the state of the quadrotor at the new time instance
        % @param dt   : time interval
        % @param input: contains 6 rotor speeds
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [ ] = tilthex_dynamics( obj, dt, input )
      
        function [ ] = delete( obj )


        end



    end

end