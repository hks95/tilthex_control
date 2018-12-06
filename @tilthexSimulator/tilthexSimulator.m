classdef tilthexSimulator < handle

    properties

        robot                  % object of the class tilthex

        world_fig_handle       % figure handle, contains world_axe_handle
        world_axe_handle       % axes handle,   contains the plot of features, the quadrobtor

        time                   % scalar, current time
        time_step              % scalar, time step of the simulation
        
        atti_control_freq      % scalar, frequency of attitude control
        atti_control_timer     % scalar, timer for attitude control event
        
        pos_control_freq       % scalar, frequency of position control
        pos_control_timer      % scalar, timer for position control event
        
        waypoints          % struct, record the planned state of trajectory planner
        curr_state             % current state of tilthex 
        control_input          % struct, record the designed input from the controller

    end

    methods

        function obj = tilthexSimulator(sim_settings,tilthex_settings,algo_settings,view_point,waypoints)

            % Create figure and axes handle for the world and the captured image
            obj.world_fig_handle = figure('Name', 'TiltHexrotor Simulator');
            obj.world_axe_handle = axes('Parent', obj.world_fig_handle);

            % Plot the waypoints in the figure
            for i=1:size(waypoints,1)      
                pt = [0 1 0;1 0 0;0 0 -1] * waypoints(i,:)';
                scatter3(obj.world_axe_handle, pt(1), pt(2), pt(3), 25, 'c*');
                % scatter3(obj.world_axe_handle, desired_state.desired_position(1,1), desired_state.desired_position(2,1), desired_state.desired_position(3,1),'c*');
            end
            
            set(obj.world_axe_handle, 'DataAspectRatio', [1 1 1], 'DataAspectRatioMode', 'manual');
            set(obj.world_axe_handle, 'XLimMode', 'manual', 'YLimMode', 'manual', 'ZLimMode', 'manual');
            set(obj.world_axe_handle, 'XLim', [view_point(1,1) view_point(1,2)], 'YLim', [view_point(2,1) view_point(2,2)], 'ZLim', [view_point(3,1) view_point(3,2)]);
            set(obj.world_axe_handle, 'NextPlot', 'add');

            % Create a quadrotor
            obj.robot = tilthex(obj.world_axe_handle, tilthex_settings,waypoints);

            % Set intial time to 0
            % Each time the simulaton runs, the time increases by time_step
            obj.time = 0;
            obj.time_step = sim_settings.time_step;

            obj.atti_control_freq = algo_settings.atti_control_freq;
            obj.pos_control_freq  = algo_settings.pos_control_freq;
           
            % Initialize the timer for different events.
            % The timer is set to the ceiling at the beginning so that all
            % the events are triggered at the beginning of the simulation.
            obj.atti_control_timer = 1 / obj.atti_control_freq;
            obj.pos_control_timer  = 1 / obj.pos_control_freq;
           
            % Set the initial state for the quadrotor
            obj.curr_state = tilthex_settings.initial_state;
            obj.waypoints = waypoints; 
            
            % Add function handles to the different events
            addlistener(obj, 'posControlEvnt',  algo_settings.pos_control_event_handler);
            addlistener(obj, 'attiControlEvnt', algo_settings.atti_control_event_handler);
            
        end

        % The interface of the simulator.
        % Forward the simulation by one time step
        [ ] = onetime_stepForward( obj )


        % Class destructor
        function delete( obj )

        end


    end

    events

        % Attitude control event
        attiControlEvnt

        % Position control event
        posControlEvnt

        % Trajectory planning event
%         trajPlanEvnt

    end

end