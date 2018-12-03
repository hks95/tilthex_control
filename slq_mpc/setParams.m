function modelParams=setParams()
%% algo 1

    modelParams.g=9.8;%9.8
    modelParams.m=2;
    modelParams.length=0.5;
    modelParams.inertia_tensor = zeros(3, 3);
    modelParams.inertia_tensor(1, 1) = 0.011; %hex_settings.mass/2 * hex_settings.link_len^2;
    modelParams.inertia_tensor(2, 2) = 0.015; %hex_settings.mass/2 * hex_settings.link_len^2;
    modelParams.inertia_tensor(3, 3) = 0.021; %hex_settings.mass   * hex_settings.link_len^2;

    modelParams.c=1;
    
    modelParams.dt=0.05;
    modelParams.T=5; %N=T/dt
    modelParams.N=modelParams.T/modelParams.dt+1;
    
    modelParams.Qt=eye(6);
    modelParams.Qf=eye(6)*10;
    modelParams.Rt=eye(6);
    
    modelParams.x_init=[0;0;1;0;0;0];
    modelParams.u_lim=2.5;
    
    modelParams.gen_traj=1;
    modelParams.viz=1;
    modelParams.printf=1;
    modelParams.ls_steps=10;
    modelParams.alpha_d=1.1;
    
    modelParams.traj_track=0; % 0 if goal tracking
    
%% algo 2

    modelParams.policy_lag=0;
    modelParams.Q_lqr=eye(6)*10;
    modelParams.mpc_steps=10;
    modelParams.goal=[1.5;0.5;2;0;0;0];
    
%     % waypoints params
%     modelParams.wp_bool=0;
%     modelParams.num_wp=1;
%     modelParams.states = [pi/2 ;...
%                             0 ];
%     modelParams.rho_p  = [100];
%     modelParams.t_p    = [50*modelParams.dt];
%     modelParams.weight_p = diag([1000,0]);
end