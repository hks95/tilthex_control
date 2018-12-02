classdef slqController < handle

    properties

    % Algorithm 1 params
    g
    m
    l
    I

    T
    dt
    N
    
    c    
    Qt
    Qf
    Rt
    
    initial_state
    desired_state
    
    ls_steps
    alpha_d
    
    traj_track % 0 if goal tracking

    % Algorithm 2 params
    policy_lag
    Q_lqr
    mpc_steps
    
    % waypoints params
    wp_bool
    num_wp
    
    rho_p
    t_p 
    weight_p
    
    actTraj
    u_ff
    u_fb
    mpc_iter
    
    end

    methods

        % Class Constructor
        function obj = slqController(hex_settings,sim_settings,desired_state )
            obj.m = hex_settings.mass;
            obj.l = hex_settings.link_len;
            obj.I = hex_settings.inertia_tensor;
            obj.c = 1;
            
            obj.T = sim_settings.sim_duration;
            obj.dt = sim_settings.time_step;
            obj.N = obj.T/obj.dt + 1;
            
            obj.Qt = diag([1,1]);
            obj.Qf = diag([10,10]);
            obj.Rt = 1;

            obj.initial_state = hex_settings.initial_state;
            obj.desired_state = desired_state;
            
            obj.ls_steps = 10;
            obj.alpha_d  = 1.1;

            obj.traj_track = 0; % 0 if goal tracking

            % Algorithm 2 params
            obj.policy_lag = 0;
            obj.Q_lqr = diag([10,10]);
            obj.mpc_steps = 10;

            % waypoints params
            obj.wp_bool = 0;
            obj.num_wp = 1;

            obj.rho_p = 100;
            obj.t_p = 50*obj.dt;
            obj.weight_p = diag([1000,0]);

            
            obj.actTraj.x =  hex_settings.initial_state;
            obj.actTraj.u = zeros(6,1);

            obj.u_ff = zeros(1,obj.N-1);
            obj.u_fb = zeros(obj.N-1,2);
            
            obj.mpc_iter = 0;            
        end

        % Interface of the algorithm
        [] = control(obj, src, event_data)

        % Class destructor
        function [] = delete(obj)

        end

    end

end



