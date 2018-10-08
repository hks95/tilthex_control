%% Initialize hexrotor

% Properties of the hexrotor
hex_settings.link_len       = 1;
hex_settings.mass           = 1;
hex_settings.inertia_tensor = zeros(3, 3);
hex_settings.inertia_tensor(1, 1) = hex_settings.mass/2 * hex_settings.link_len^2;
hex_settings.inertia_tensor(2, 2) = hex_settings.mass/2 * hex_settings.link_len^2;
hex_settings.inertia_tensor(3, 3) = hex_settings.mass   * hex_settings.link_len^2;

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
hex_settings.initial_state.R           = eye(3); %maybe change according to ned
hex_settings.initial_state.yaw         = 0;
hex_settings.initial_state.pitch       = 0;
hex_settings.initial_state.roll        = 0;
hex_settings.initial_state.angular_vel = [0 0 0]';
hex_settings.initial_state.angular_acc = zeros(3, 1);
hex_settings.initial_state.position    = [0 0 0]';
hex_settings.initial_state.linear_vel  = [0 0 0]; %[0 1 0]';
hex_settings.initial_state.linear_acc  = [0 0 1]; %[-1 0 1]';

%% Initialize the simulator

% Total simulation time
sim_duration = 2;

% Some properties of the world
% sim_settings.features  = features;
% sim_settings.colors    = colors;
sim_settings.time_step = 0.1;

% Create an object of the simulator
my_simulator = tilthexSimulator(sim_settings, hex_settings);