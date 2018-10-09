classdef tilthexSimulator < handle

    properties

        robot                  % object of the class tilthex

        world_fig_handle       % figure handle, contains world_axe_handle
        world_axe_handle       % axes handle,   contains the plot of features, the quadrobtor

        time                   % scalar, current time
        time_step              % scalar, time step of the simulation
        
        curr_state             % current state of tilthex 
        control_input          % struct, record the designed input from the controller

    end

    methods

        function obj = tilthexSimulator( sim_settings, tilthex_settings)

            % Create figure and axes handle for the world and the captured image
            obj.world_fig_handle = figure('Name', 'Quadrotor Simulator');
            obj.world_axe_handle = axes('Parent', obj.world_fig_handle);

            % Scatter the features in the world
            % scatter3(obj.world_axe_handle, obj.features(1, :), obj.features(2, :), obj.features(3, :), 25, obj.feature_colors', 'filled');
            scatter3(obj.world_axe_handle, 0, 0, 0, 25, 'filled');
            set(obj.world_axe_handle, 'DataAspectRatio', [1 1 1], 'DataAspectRatioMode', 'manual');
            set(obj.world_axe_handle, 'XLimMode', 'manual', 'YLimMode', 'manual', 'ZLimMode', 'manual');
            set(obj.world_axe_handle, 'XLim', [-5.5 5.5], 'YLim', [-5.5 5.5], 'ZLim', [-5 5]);
            set(obj.world_axe_handle, 'NextPlot', 'add');

            % Create a quadrotor
            obj.robot = tilthex(obj.world_axe_handle, tilthex_settings);

            % Set intial time to 0
            % Each time the simulaton runs, the time increases by time_step
            obj.time = 0;
            obj.time_step = sim_settings.time_step;

            % Set the initial state for the quadrotor
            obj.curr_state = tilthex_settings.initial_state;

        end

        % The interface of the simulator.
        % Forward the simulation by one time step
        [ ] = onetime_stepForward( obj )


        % Class destructor
        function delete( obj )

        end


    end

%     events

        % State estimation event
%         stateEstEvnt

        % Attitude control event
%         attiControlEvnt

        % Position control event
%         posControlEvnt

        % Trajectory planning event
%         trajPlanEvnt

%     end

end