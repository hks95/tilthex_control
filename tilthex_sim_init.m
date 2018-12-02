%% Initialize hexrotor

% Properties of the hexrotor
hex_settings.link_len       = 0.5;
hex_settings.mass           = 2;
hex_settings.inertia_tensor = zeros(3, 3);
hex_settings.inertia_tensor(1, 1) = 0.011; %hex_settings.mass/2 * hex_settings.link_len^2;
hex_settings.inertia_tensor(2, 2) = 0.015; %hex_settings.mass/2 * hex_settings.link_len^2;
hex_settings.inertia_tensor(3, 3) = 0.021; %hex_settings.mass   * hex_settings.link_len^2;

%% Defining rotor frames
alpha = 60;
beta = 60;
psi_dihed = 15;
phi_x = 0;
phi_y = 40; %actual i think we have 60

% rotor numbering based on paper
% 1,3,5 ccw
% 2,4,6 cw
%conversion from rotor to ned

% rotor 1
T_MtoB = [-cosd(alpha) -sind(alpha) 0;sind(alpha) -cosd(alpha) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 -sind(phi_y);0 1 0;sind(phi_y) 0 cosd(phi_y)];
hex_settings.rotor1 = T_MtoB*T_NtoM*T_RtoN;

% rotor 2
T_MtoB = [-1 0 0;0 -1 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 sind(phi_y);0 1 0;-sind(phi_y) 0 cosd(phi_y)];
hex_settings.rotor2 = T_MtoB*T_NtoM*T_RtoN;

% rotor 3
T_MtoB = [-cosd(beta) sind(beta) 0;-sind(beta) -cosd(beta) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 -sind(phi_y);0 1 0;sind(phi_y) 0 cosd(phi_y)];
hex_settings.rotor3 = T_MtoB*T_NtoM*T_RtoN;

% rotor 4
T_MtoB = [cosd(alpha) sind(alpha) 0;-sind(alpha) cosd(alpha) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 sind(phi_y);0 1 0;-sind(phi_y) 0 cosd(phi_y)];
hex_settings.rotor4 = T_MtoB*T_NtoM*T_RtoN;

% rotor 5
T_MtoB = [1 0 0;0 1 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 -sind(phi_y);0 1 0;sind(phi_y) 0 cosd(phi_y)];
hex_settings.rotor5 = T_MtoB*T_NtoM*T_RtoN;

% rotor 6
T_MtoB = [cosd(beta) -sind(beta) 0;sind(beta) cosd(beta) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 sind(phi_y);0 1 0;-sind(phi_y) 0 cosd(phi_y)];
hex_settings.rotor6 = T_MtoB*T_NtoM*T_RtoN;


%% Inital state of the hexrotor
hex_settings.initial_state.R           = eye(3); %big equation world to body
hex_settings.initial_state.yaw         = 0;
hex_settings.initial_state.pitch       = 0;
hex_settings.initial_state.roll        = 0;
hex_settings.initial_state.angular_vel = [0 0 0]';
hex_settings.initial_state.angular_acc = zeros(3, 1);
hex_settings.initial_state.position    = [0 0 0]';
hex_settings.initial_state.linear_vel  = [0 0 0]'; %[0 1 0]';
hex_settings.initial_state.linear_acc  = [0 0 1]'; %[-1 0 1]';

%% Initial state of arm
hex_settings.arm_initial_state.theta1 = 0;
hex_settings.arm_initial_state.theta2 = pi/10;
hex_settings.arm_initial_state.theta3 = 2*pi/3;
hex_settings.arm_initial_state.theta1_dot = 0;
hex_settings.arm_initial_state.theta2_dot = 0;
hex_settings.arm_initial_state.theta3_dot = 0;
hex_settings.arm_initial_state.L0 = 0.078767;% vertical offset from the second motor to the base
hex_settings.arm_initial_state.L1 =  0.020728; % horizontal offset from the z axis to the second motor'
hex_settings.arm_initial_state.L2 = 0.107;
hex_settings.arm_initial_state.L3 = 0.300;
hex_settings.arm_initial_state.L4 = 0.320;
hex_settings.arm_initial_state.F = [0;0;0];
hex_settings.arm_initial_state.M = [0;0;0];

%% Intialize the controller

% Attitude controller
atti_control_settings.Kr         = 240*eye(3);
atti_critical_damp               = 4.5*atti_control_settings.Kr*hex_settings.inertia_tensor;
atti_control_settings.Kw         = diag(sqrt(diag(atti_critical_damp)));
atti_control_settings.freq       = 200;
atti_control_settings.max_torque = 120*ones(3, 1);
atti_controller                  = controller.attiController(atti_control_settings);

% Position controller
pos_control_settings.Kp         =  100*eye(3);
pos_critical_damp               = 3.5*pos_control_settings.Kp*hex_settings.mass;
pos_control_settings.Kd         = diag(sqrt(diag(pos_critical_damp)));
pos_control_settings.mass       = hex_settings.mass;
pos_control_settings.freq       = 100;
pos_control_settings.max_thrust = 2*9.8*hex_settings.mass;
pos_controller = controller.posController(pos_control_settings);

% algo settings
algo_settings.atti_control_freq = atti_control_settings.freq;
algo_settings.pos_control_freq  = pos_control_settings.freq;

algo_settings.atti_control_event_handler = @atti_controller.control;
algo_settings.pos_control_event_handler  = @pos_controller.control;

%% Planner
% look at OneTimeStepForward
desired_state.desired_yaw        = 0;
desired_state.desired_position = [1.5;-0.5;-1.5];
desired_state.desired_linear_vel = [0;0;0];
desired_state.desired_linear_acc = [0;0;0];
%% Initialize the simulator

% Total simulation time
sim_duration = 20;

% Some properties of the world
% sim_settings.features  = features;
% sim_settings.colors    = colors;
sim_settings.time_step = 0.01; 

% view points
view_point = [-2 2;-2 2;-2 2];
% Create an object of the simulator
my_simulator = tilthexSimulator(sim_settings, hex_settings,algo_settings,view_point,desired_state);