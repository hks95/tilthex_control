% important matrices 
function [] = rotor_axes(obj)

alpha = 60;
beta = 60;
psi_dihed = 15;
phi_x = 0;
phi_y = 40; %actual i think we have 60

% rotor numbering based on paper
% 1,3,5 ccw
% 2,4,6 cw

%% rotor 1
T_MtoB = [-cosd(alpha) -sind(alpha) 0;sind(alpha) -cosd(alpha) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 -sind(phi_y);0 1 0;sind(phi_y) 0 cosd(phi_y)];
obj.rotor1 = T_MtoB*T_NtoM*T_RtoN;

%% rotor 2
T_MtoB = [-1 0 0;0 -1 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 sind(phi_y);0 1 0;-sind(phi_y) 0 cosd(phi_y)];
obj.rotor2 = T_MtoB*T_NtoM*T_RtoN;

%% rotor 3
T_MtoB = [-cosd(beta) sind(beta) 0;-sind(beta) -cosd(beta) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 -sind(phi_y);0 1 0;sind(phi_y) 0 cosd(phi_y)];
obj.rotor3 = T_MtoB*T_NtoM*T_RtoN;

%% rotor 4
T_MtoB = [cosd(alpha) sind(alpha) 0;-sind(alpha) cosd(alpha) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 sind(phi_y);0 1 0;-sind(phi_y) 0 cosd(phi_y)];
obj.rotor4 = T_MtoB*T_NtoM*T_RtoN;

%% rotor 5
T_MtoB = [1 0 0;0 1 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 -sind(phi_y);0 1 0;sind(phi_y) 0 cosd(phi_y)];
obj.rotor5 = T_MtoB*T_NtoM*T_RtoN;

%% rotor 6
T_MtoB = [cosd(beta) -sind(beta) 0;sind(beta) cosd(beta) 0;0 0 1];
T_NtoM = [1 0 0;0 cosd(phi_x) -sind(phi_x);0 sind(phi_x) cosd(phi_x)];
T_RtoN = [cosd(phi_y) 0 sind(phi_y);0 1 0;-sind(phi_y) 0 cosd(phi_y)];
obj.rotor6 = T_MtoB*T_NtoM*T_RtoN;


end



